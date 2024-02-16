extends Area2D

func kill():
	yield(get_tree().create_timer(0.2), "timeout")
	get_parent().queue_free()
	queue_free()
