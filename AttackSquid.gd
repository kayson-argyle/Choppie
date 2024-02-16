extends Sprite

var tween = Tween.new()

func _process(delta):
	get_parent().damage(delta * 4)


func ok():
	rotation = position.angle() + PI / 2
	add_child(tween)
	tween.interpolate_property(self, "position", position, position * 0.6, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
