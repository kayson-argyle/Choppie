extends Node2D

var random = RandomNumberGenerator.new()
var explosion = preload("res://Explosion.tscn")
onready var player = Global.player
onready var camera = Global.camera
 
func _ready():
	random.randomize()
	$Physics/Fruit.frame = random.randi_range(0, 2)



func _on_Physics_body_entered(body):
	if "Player" in body.get_name():
		player.damage(100)
		camera.shake(0.5, 0.8, 0.2, 30)
	var explode = explosion.instance()
	$"../".add_child(explode)
	explode.emitting = true
	explode.global_position = $Physics.global_position
	queue_free()
