extends ColorRect

var tween = Tween.new()

func _ready():
	add_child(tween)
	modulate.a = 1
	yield(get_tree().create_timer(0.5), "timeout")
	call_deferred("transition", "in", 1)

func transition(direction, time):
	if direction == "out":
		tween.interpolate_property(self, "modulate:a", 0, 1, time)
		tween.start()
	if direction == "in":
		modulate.a = 1
		tween.interpolate_property(self, "modulate:a", 1, 0, time)
		tween.start()

