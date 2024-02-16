
extends Sprite

export var popForce = 130
export var stationary = true
export var setPos = Vector2.ZERO
export var sinPos = Vector2.ZERO
var initPos = Vector2.ZERO
var random = RandomNumberGenerator.new()
var popped = false
var popTimer = 0
export var regrowTime = 1
var tween = Tween.new()
export var spawnSeed = false
export var seedType = "Acorn"
export var spawnSquid = false


func _ready():
	if spawnSeed:
		var s = load("res://Seed.tscn").instance()
		$Holder.add_child(s)
		s.doTimer = false
		s.setType(seedType)
	if spawnSquid:
		var s = load("res://SkySquid.tscn").instance()
		$Holder.add_child(s)
	add_child(tween)
	random.randomize()
	initPos = global_position
	$AnimationPlayer.advance(random.randf_range(0, 3))
	$AnimationPlayer.playback_speed = random.randf_range(0.75, 1.25)
	for i in $Holder.get_children():
		i.set_process(false)
		i.set_physics_process(false)
		if i.has_node("ProgressBar"):
			i.get_node("ProgressBar").visible = false
		if i.has_node("Pick Up"):
			i.collision_mask = 0
			i.collision_layer = 0
			i.active = false
			i.gravity_scale = 0

func _process(delta):
	global_position = setPos + initPos + sinPos
	if popped:
		popTimer += delta
		if popTimer > regrowTime:
			popped = false
			regrow()

func regrow():
	self_modulate.a = 1
	scale = Vector2.ZERO
	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	$Area2D.collision_mask = 1
	$Area2D.collision_layer = 1


func _on_Area2D_area_entered(area):
	if "Jump" == area.get_name():
		if Global.player.motion.y > -popForce:
			Global.player.motion.y = -popForce
			self_modulate.a = 0
			$Particles2D.emitting = true
			$Area2D.collision_mask = 0
			$Area2D.collision_layer = 0
			popped = true
			popTimer = 0
			Global.player.jumpTimer = 0.02
			Sounds.playPosSound("res://bubblePop.wav", global_position)
			for i in $Holder.get_children():
				$Holder.remove_child(i)
				i.set_process(true)
				i.set_physics_process(true)
				get_parent().call_deferred("add_child", i)
				i.global_position = global_position
				if i.has_node("ProgressBar"):
					i.get_node("ProgressBar").visible = true
				if i.has_node("Pick Up"):
					i.get_node("Pick Up").scale = Vector2(3, 3)
					i.gravity_scale = Global.gravityScale
					i.active = true
					i.collision_mask = 7
					i.collision_layer = 7
