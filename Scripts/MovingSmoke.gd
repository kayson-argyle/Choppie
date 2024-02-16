tool
extends Particles2D

var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()

var timer = 0
var offsety = Vector2.ZERO

func _process(delta):
	timer += delta
	offsety += Vector2(random.randf_range(-0.1, 0.1), random.randf_range(-0.1, 0.1))
	position.x = sin(timer * 2) * 200
	position.y = cos(timer * 2) * 200
	rotation_degrees += delta * random.randf_range(14, 15)
