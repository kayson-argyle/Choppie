extends Label
var lowestRate = 100
var timer = 0

func _process(delta):
	yield(get_tree().create_timer(5), "timeout")
	if delta > lowestRate:
		text = str(delta)
		lowestRate = delta
	timer += delta
	if timer > 3:
		timer = 0
		text = str(delta)
