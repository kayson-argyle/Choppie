extends Sprite

var inDoorWay = false
var inHouse = false

func _on_Area2D_area_entered(area):
	if "Item Pick" in area.get_name():
		inDoorWay = true

func _on_Area2D_area_exited(area):
	if "Item Pick" in area.get_name():
		inDoorWay = false

func _physics_process(_delta):
	if Input.is_action_just_released("ui_down"):
		if inDoorWay:
			if inHouse:
				$Tween.interpolate_property(self, "self_modulate:a", self_modulate.a, 1, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				$Tween.start()
				$Walls.set_collision_layer(0)
				inHouse = false
			else:
				$Tween.interpolate_property(self, "self_modulate:a", self_modulate.a, 0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				$Tween.start()
				$Walls.set_collision_layer(1)
				inHouse = true
