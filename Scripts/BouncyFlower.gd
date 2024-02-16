extends Sprite

var areas = []

func _process(_delta):
	if !areas.empty():
		for i in range(areas.size()):
			#areas[i].get_parent().get_parent().motion.y *= -1
			areas[i].get_parent().get_parent().jumpTimer = 0.021

func _on_Area2D_area_entered(area):
	areas.append(area)
	area.get_parent().get_parent().motion.y *= -1

func _on_Area2D_area_exited(area):
	var remove = areas.find(area)
	areas.remove(remove)
