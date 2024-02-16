extends Interactable

var canGo = false

func interact():
	if canGo:
		Global.changeScene("res://Tournament.tscn")

func select():
	if canGo:
		Global.dialogue.open({ "0" : "travel to the hero's camp?"})
	

func deselect():
	if canGo:
		Global.dialogue.close()
