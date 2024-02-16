extends CollisionPolygon2D

func _process(_delta):
	global_position = $"../../../Jaw".global_position
	global_rotation = $"../../../Jaw".global_rotation
