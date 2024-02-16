extends Area2D

var teleported = true

func _on_Teleporter_body_entered(body):
	if body.name == "Player" and teleported:
		teleported = false
		var closestNode = $Points/Position2D
		for i in $Points.get_children():
			if abs(i.global_position.x - body.global_position.x) < abs(closestNode.global_position.x - body.global_position.x):
				closestNode = i
		body.get_node("CameraHolder/Camera2D/CanvasLayer/Control/CanvasLayer/Transition").transition("out", 0.25)
		yield(get_tree().create_timer(0.25), "timeout")
		if not teleported:
			body.global_position = closestNode.global_position
			teleported = true
			body.get_node("CameraHolder/Camera2D/CanvasLayer/Control/CanvasLayer/Transition").transition("in", 0.5)
