extends Particles2D

func _ready():
	emitting = true
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.35
	timer.start()
	yield(timer, "timeout")
	queue_free()
