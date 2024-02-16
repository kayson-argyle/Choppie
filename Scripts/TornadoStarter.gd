extends Particles2D

var timer = 0
var tween = Tween.new()

func _ready():
	add_child(tween)
	tween.interpolate_property(self, "self_modulate:a", 1, 0, 2, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.interpolate_property($Light2D, "modulate:a", 0.3, 0, 2)
	tween.start()

func _process(delta):
	
	timer += delta
	if timer > 2:
		queue_free()
