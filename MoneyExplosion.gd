extends Node2D

var exploded = false
var timer = 0
export var amount = 10
var random = RandomNumberGenerator.new()
var power = 5

			
func explode():
	if exploded:
		pass
	exploded = true
	$Money.turnOn()
	for i in amount:
		var money = get_child(0).duplicate()
		get_tree().get_current_scene().add_child(money)
		money.turnOn()
		money.collisionExclusion = get_parent()
		money.global_position = global_position
		money.linear_velocity.x = random.randf_range(-10 * power, 10 * power)
		money.linear_velocity.y = random.randf_range(-20 * power, 0)
		Sounds.playPosSound("res://coinSplash.wav", global_position)
	#get_child(0).queue_free()
