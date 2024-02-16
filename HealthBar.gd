tool
extends Sprite

var size = 0.5

func _process(_delta):
	for i in get_children():
		if "scale" in i:
			i.global_scale.x = size
