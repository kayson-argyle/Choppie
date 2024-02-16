tool
extends Sprite

export var amplitude = 1
export var speed = 1
var wobble = true
var timer = 0
var r = RandomNumberGenerator.new()

onready var initPos = global_position

func _ready():
	r.randomize()
	timer += r.randf_range(0, 6)

func _process(delta):
	if Engine.editor_hint:
		$Area2D/Collision.polygon = $Body/CollisionPolygon2D.polygon
#		if texture.get_width() == 24:
#			$Body/CollisionPolygon2D.polygon = [Vector2(-2, 5), Vector2(-9, -5), Vector2(10, -5), Vector2(5, 3), Vector2(2, 0)]
	else:
		if wobble:
			timer += delta
			global_position = initPos + Vector2(0, amplitude * sin(timer * speed))



func _on_Area2D_area_exited(area):
	if area.name == "Jump":
		wobble = true


func _on_Area2D_area_entered(area):
	if area.name == "Jump":
		wobble = false
