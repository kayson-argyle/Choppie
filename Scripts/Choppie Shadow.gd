extends Sprite

var motion = Vector2.ZERO

onready var player = get_node("/root/World/Player")
onready var ray = get_node("/root/World/Player/RayCast2D")
var distToFloor = 0

func _process(_delta):
	distToFloor = ray.get_collision_point().y - (player.position.y)
	position.y = distToFloor
	modulate.a = pow(1.04, -distToFloor)
	if ray.is_colliding():
		visible = true
	else:
		visible = false


