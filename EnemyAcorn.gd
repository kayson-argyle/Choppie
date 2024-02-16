extends RigidBody2D

var timer = Timer.new()
var pop = false
var startPos
var measured = false
var posy = 0
var airTime = 0

func _process(delta):
	posy = global_position.y
	airTime += delta
	

func _ready():
	add_child(timer)
	timer.wait_time = 1.5
	timer.start()
	yield(timer, "timeout")
	pop()

func _on_Area2D_body_entered(body):
	if "Player" in body.get_name():
		body.damage(100)
		body.get_node("CameraHolder/Camera2D").shake(0.5, 0.8, 0.2, 30)
		pop()
		
		
func pop():
	if not pop:
		pop = true
		$Particles2D.emitting = true
		$Sprite.visible = false
		$CollisionPolygon2D.disabled = true
		$Area2D/CollisionPolygon2D2.disabled = true
		timer.start(0.5)
		yield(timer, "timeout")
		queue_free()
