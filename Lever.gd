extends Interactable

class_name Lever

var pulled = false

func select():
	$Handle/Outline.visible = true
	
func deselect():
	$Handle/Outline.visible = false
	
func interact():
	Sounds.playPosSound("res://lever.wav", global_position, 0, 0.3, 1)
	pulled = not pulled
	if pulled:
		action()
	else:
		inaction()


func action():
	$Handle.rotation_degrees = 30
	pass

func inaction():
	$Handle.rotation_degrees = 0
	pass
