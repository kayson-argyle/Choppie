tool
extends Sprite

var timer = 0

func _process(delta):
	timer += delta
#	modulate.h = (sin(timer) + 1) / 2
	modulate.s = (cos(timer) + 1.5) / 3
	modulate.h = timer/5
#	modulate.s = timer/10
