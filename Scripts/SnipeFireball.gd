extends Sprite

var explosion = preload("res://Explosion.tscn")
var velocity = Vector2.ZERO
var tornadoStarter = false

func _process(delta):
	position += velocity * delta

func _on_Area2D_body_entered(body):
	if "Player" in body.get_name():
		body.damage(100)
		body.get_node("CameraHolder/Camera2D").shake(0.5, 0.8, 0.2, 30)
	elif body.has_method("damage"):
		body.damage(250)
	if !tornadoStarter:
		var explode = explosion.instance()
		Sounds.playPosSound("res://Boom.wav", global_position, 350, 10, 0.2, 1, 1)
		$"../".add_child(explode)
		explode.emitting = true
		explode.global_position = global_position
		queue_free()
	if "Fortress" in body.get_name() and tornadoStarter:
		var explode = explosion.instance()
		Sounds.playPosSound("res://Boom.wav", global_position, 350, 10, 0.2, 1, 1)
		$"../".add_child(explode)
		explode.emitting = true
		explode.global_position = global_position
		var tornadoStarterFire = load("res://TornadoStarter.tscn").instance()
		$"../".add_child(tornadoStarterFire)
		tornadoStarterFire.global_position = global_position
		$"../../".tornadoStartPos = global_position
		queue_free()


func _on_Area2D_area_entered(area):
	if "SeedCollision" in area.get_name() and !tornadoStarter:
		area.get_parent().destroy()
