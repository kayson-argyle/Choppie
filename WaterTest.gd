extends Node2D

export var resolution = 2
export var splashRange = 5

var pointVelocities = []

func _ready():
	var size = $Area2D/CollisionShape2D.shape.extents.x * 2 * resolution
	for p in range(size + 1):
		var pos = Vector2((p - size/2) / resolution, $Area2D.position.y - $Area2D/CollisionShape2D.shape.extents.y)
		$Line2D.add_point(pos)
		pointVelocities.append(0)
		

func _process(delta):
	for i in pointVelocities:
		$Line2D.set_point_position(i, Vector2($Line2D.get_point_position(i).x, $Line2D.get_point_position(i).y + pointVelocities[i] * delta))

func _on_Area2D_body_entered(body):
	if "motion" in body:
		pass
