extends KinematicBody2D

var velocity = Vector2(0,0)
var physics = false

func _physics_process(delta):
	if physics:
		velocity.y += Global.gravity * delta
# warning-ignore:return_value_discarded
		move_and_slide(velocity, Vector2.ZERO)
		
func force(x, y):
	physics = true
	velocity.x = x
	velocity.y = y

func get_damage():
	$Sprite.visible = false
	$SeedCollision.collision_mask = 0
	$SeedCollision.collision_layer = 0
	var dust = load("res://WoodDust.tscn").instance()
	add_child(dust)
	dust.emitting = true
	return 3

func destroy():
	get_damage()
