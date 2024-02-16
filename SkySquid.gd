tool
extends Enemy

var stateMachine 
var dist = 0
export var attackRange = 40
export var fleeRange = 10
export var absRange = 100
var tween = Tween.new()
var rotTween = 0
var rotInit = 0
var rotTarget = 0
var doRotate = false

var bbSquid = preload("res://BabySquid.tscn")

func _ready():
	add_child(tween)
	stateMachine = $Stuff/Polygon2D/AnimationTree.get("parameters/playback")
	

func _on_Eyes_animation_finished(anim_name):
	if "Idle" in anim_name:
		$Stuff/Polygon2D/Eyes.play("Blink" + str(random.randi_range(1, 2)))
	else:
		$Stuff/Polygon2D/Eyes.play("Idle")
		

func _process(_delta):
	
	if Engine.editor_hint:
		pass
#		$Stuff/FleeRadius.shape.radius = fleeRange
#		$Stuff/AttackRadius.shape.radius = attackRange
	else:
		dist = (Global.player.global_position + Vector2(0, -7) - global_position).length()
		
		if dist > absRange:
			rotTarget = 0
			stateMachine.travel("Idle")
			
		elif dist > attackRange:
			rotTarget = ((Global.player.global_position + Vector2(0, -7) - global_position).angle() + PI/2)
			stateMachine.travel("Swim")
		elif dist > fleeRange:
			rotTarget = ((Global.player.global_position + Vector2(0, -7) - global_position).angle() - PI/2)
			checkRot()
			checkRot()
			if abs(rotTarget - $Stuff.rotation) < 0.4:
				stateMachine.travel("Shoot")
			else:
				stateMachine.travel("Idle")
		else:
			rotTarget = ((Global.player.global_position + Vector2(0, -7) - global_position).angle() - PI/2)
			stateMachine.travel("Swim")
			
		checkRot()
		checkRot()
			
		if stateMachine.get_current_node() != "Shoot" and not tween.is_active() and abs(rotTarget - rotation) > 0.4:
			tween.interpolate_property(self, "rotTween", 0, 1, 1.5, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			tween.start()
			rotInit = $Stuff.rotation
			
		if tween.is_active():
			$Stuff.rotation = rotTween * (rotTarget - rotInit) + rotInit
		else:
			rotTween = 0
		
func checkRot():
	if (rotTarget - rotInit) > PI:
			rotTarget -= 2 * PI
	if (rotTarget - rotInit) < -PI:
		rotTarget += 2 * PI

func swim(force):
	var angle = $Stuff.rotation - PI/2
	if tween.is_active():
		force = force/2
	apply_central_impulse(force * Vector2(cos(angle), sin(angle)))

func shoot():
	var angle = $Stuff.rotation + PI/2
	var bbInst = bbSquid.instance()
	bbInst.collision_layer = 1
	bbInst.collision_mask = 1
	bbInst.z_index = -1
	get_parent().add_child(bbInst)
	bbInst.get_node("Stuff").global_rotation_degrees = $Stuff.global_rotation_degrees - 180
	bbInst.global_position = global_position
	bbInst.apply_central_impulse(30 * Vector2(cos(angle), sin(angle)))
