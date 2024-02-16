tool
extends Enemy

var stateMachine 
var dist = 0
export var attackRange = 7
export var absRange = 50
var tween = Tween.new()
var rotTween = 0
var rotInit = 0
var rotTarget = 0
var doRotate = false
var collisionTimer = 0
var dead = false
var setCollisions = true

func _ready():
	add_child(tween)
	stateMachine = $Stuff/Sprite/AnimationTree.get("parameters/playback")



func _process(delta):
	
	
	if Engine.editor_hint:
		pass
#		$Stuff/FleeRadius.shape.radius = fleeRange
#		$Stuff/AttackRadius.shape.radius = attackRange
	else:
		doFlash = false
		doShake = false
		damage(delta * 4)
		doFlash = true
		doShake = true
		dist = (Global.player.global_position + Vector2(0, -11) - global_position).length()
		if dist > absRange:
			stateMachine.travel("Idle")
		elif dist > attackRange:
			rotTarget = ((Global.player.global_position + Vector2(0, -11) - global_position).angle() + PI/2)
			stateMachine.travel("Swim")
		else:
			rotTarget = ((Global.player.global_position + Vector2(0, -11) - global_position).angle() - PI/2)
			stateMachine.travel("Suck")
			if get_parent().name != "Things" and not dead:
				var pos = global_position
				get_parent().remove_child(self)
				linear_velocity = Vector2.ZERO
				linear_damp = 99999
				collision_layer = 0
				collision_mask = 0
				mass = 99999
				Global.player.get_node("Things").add_child(self)
				scale.x = get_parent().scale.x
				global_position = pos
			doFlash = false
			doShake = false
			damage(-delta * 6)
			doFlash = true
			doShake = true
			
			
		if (rotTarget - rotInit) > PI:
			rotTarget -= 2 * PI
		if (rotTarget - rotInit) < -PI:
			rotTarget += 2 * PI
			
		if stateMachine.get_current_node() != "Suck" and not tween.is_active() and abs(rotTarget - $Stuff.rotation) > 0.2:
			tween.interpolate_property(self, "rotTween", 0, 1, 1.5, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			tween.start()
			rotInit = $Stuff.rotation
			
		if tween.is_active() and not dead:
			$Stuff.rotation = rotTween * (rotTarget - rotInit) + rotInit
		else:
			rotTween = 0
			
		if health <= 0:
			stateMachine.travel("Die")
		
		if collisionTimer < 0.5:
			collisionTimer += delta
		elif setCollisions:
			setCollisions = false
			collision_layer = 6
			collision_mask = 6
			z_index = 7

func death():
	$ProgressBar.visible = false
	setCollisions = true
	dead = true
	var pos = global_position
	if get_parent().get("scale") != null:
		scale.x = scale.x * get_parent().scale.x
	var root = get_tree().get_current_scene()
	get_parent().remove_child(self)
	root.add_child(self)
	global_position = pos
	mass = 1
	linear_damp = 0.5
	if stateMachine.get_current_node() == "Suck":
		var angle = $Stuff.rotation - PI/2
		apply_central_impulse(3 * Vector2(cos(angle), sin(angle)))
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3
	timer.start()
	yield(timer, "timeout")
	tween.interpolate_property(self, "scale", scale, Vector2(0, 0), 0.2, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	timer.wait_time = 1
	timer.start()
	yield(timer, "timeout")
	queue_free()


func swim(force):
	var angle = $Stuff.rotation - PI/2
	apply_central_impulse(force * Vector2(cos(angle), sin(angle)))

func suck():
	Global.player.damage(10)
