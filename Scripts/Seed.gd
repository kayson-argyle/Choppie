
extends RigidBody2D

class_name Seed

var move = false
export var type = "Acorn"
var tween = Tween.new()
var timer = Timer.new()
export var doTimer = true
var fromTree = false
export var active = true
var initDist = 0
var playSound = true
var pickMeUp = false
export var despawnTime = 25

func _ready():
	if type == "":
		queue_free()
	if not active:
		playSound = false
	setType(type)
	var t = Timer.new()
	add_child(t)
	t.wait_time = 1
	t.start()
	yield(t, "timeout")
	t.queue_free()
	$Sprite.frame = Global.seedNames.find(type)
	add_child(timer)
	timer.wait_time = despawnTime
	if doTimer:
		timer.start()
	if active:
		gravity_scale = Global.gravityScale
	yield(timer, "timeout")
	add_child(tween)
	tween.interpolate_property(self, "scale", scale, Vector2(0, 0), 0.25, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	collision_mask = 0
	collision_layer = 0
	get_child(0).visible = false
	var dusty = load("res://WoodDust.tscn")
	var dust = dusty.instance()
	add_child(dust)
	dust.emitting = true
	timer.stop()
	timer.wait_time = 1
	timer.start()
	yield(timer, "timeout")
	queue_free()
	
func _process(delta):
	if move:
		tween.stop_all()
		timer.stop()
		var lerpAmount = 35 * delta
		lerpAmount = clamp(lerpAmount, 0, 1)
		global_position = lerp(global_position, Global.player.global_position + Vector2(0, -7), lerpAmount)
		var dist = (Global.player.global_position + Vector2(0, -7) - global_position).length()
		$Sprite.scale = Vector2(dist/initDist, dist/initDist)
		$Sprite.scale.x = clamp($Sprite.scale.x, 0, 1)
		$Sprite.scale.y = clamp($Sprite.scale.y, 0, 1)
		if $Sprite.scale.x < 0.2:
			if fromTree:
				get_parent().get_parent().acornAmount += 1
			queue_free()

func _on_Pick_Up_area_entered(area):
	if "Item Pick" in area.get_name():
		pickMeUp = true
		if active:
			pickUp()


func pickUp():
	if Global.changeItemAmount(type, 1):
		if playSound:
			Sounds.playSound("res://bubblePop.wav")
		move = true
		collision_layer = 0
		collision_mask = 0
		initDist = (Global.player.global_position + Vector2(0, -7) - global_position).length()
		if initDist == 0:
			initDist = 0.01


func setType(t):
	type = t
	$Sprite.frame = Global.seedNames.find(type)

func activate():
	active = true
	playSound = true
	if pickMeUp:
		pickUp()
	


func _on_Pick_Up_area_exited(area):
	if "Item Pick" in area.get_name():
		pickMeUp = false

