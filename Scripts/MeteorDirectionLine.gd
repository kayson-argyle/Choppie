tool
extends Line2D

func _process(_delta):
	if Engine.editor_hint:
		points[1] = Vector2(cos(deg2rad(get_parent().angle)), sin(deg2rad(get_parent().angle)))
		points[1] *= get_parent().speed
	else:
		queue_free()
