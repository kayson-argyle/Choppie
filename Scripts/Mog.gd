extends Polygon2D

var playerIn = false

func _on_Area2D_area_entered(area):
	if "Item Pick" in area.get_name():
		playerIn = true

func _on_Area2D_area_exited(area):
	if "Item Pick" in area.get_name():
		playerIn = false
