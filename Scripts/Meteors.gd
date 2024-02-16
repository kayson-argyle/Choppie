extends KinematicBody2D

var randomSize = true
var size = 3
var velocity = Vector2.ZERO
onready var rotationSpeed = random.randf_range(-360, 360)

var random = RandomNumberGenerator.new()
var particles = preload("res://Explosion.tscn")

func _ready():
	if randomSize:
		random.randomize()
		$Meteors.frame = random.randi_range(0, 2)
	else:
		$Meteors.frame = 3 - size

func _process(delta):
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	rotation_degrees += rotationSpeed * delta

func _on_Area2D_area_entered(_area):
	explode()
	
func _on_Area2D_body_entered(_body):
	explode()

func explode():
	Sounds.playPosSound("res://Boom.wav", global_position, 200, 15)
	var pinst = particles.instance()
	get_parent().add_child(pinst)
	pinst.global_position = global_position
	pinst.scale = Vector2(size, size)
	var playerDist = (Global.player.global_position - global_position).length()
	if playerDist < 30 * size:
		Global.player.motion.x += (((30 * size) - playerDist) * 3) * (Global.player.global_position - global_position).normalized().x
		Global.player.motion.y -= ((30 * size) - playerDist)/4
		
	queue_free()
