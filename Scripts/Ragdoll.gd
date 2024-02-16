extends RigidBody2D

var pos = Vector2()
var timer = 0
var posTimer = 0
onready var camera = $Camera/Camera2D

func _ready():
	camera.global_position = Global.camera.global_position
	camera.zoom = Global.camera.zoom
	camera.current = true


func _process(delta):
	camera.global_position = lerp(camera.global_position, global_position, delta * 5)
	camera.zoom = lerp(camera.zoom, Vector2.ONE, delta)

	if posTimer > 1 or timer > 6:
		var gameOver = $Camera/Camera2D/GameOver
		gameOver.show()
		set_process(false)
		get_tree().paused = true
		
		
		
	if(pos - position).length() < 8 * delta:
		posTimer += delta
	else:
		posTimer = 0
	
	timer += delta
	pos = position


func _on_Ragdoll_tree_exiting():
	Global.camera.current = true
	Global.player.get_node("Sprite").visible = true
	Global.camera.find_node("Control").modulate.a = 1
	
	get_tree().paused = true
