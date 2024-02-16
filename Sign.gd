extends Interactable

class_name Travel

export var canGo = true
export var toScene = "res://Tournament.tscn"
export var dialogue = { "0" : "travel to the hero's camp?"}
export var setPostion = false
export var toPosition = Vector2()

func interact():
	if canGo:
		Global.changeScene(toScene, 1, setPostion, toPosition)

func select():
	if canGo and dialogue.size() > 0:
		Global.dialogue.open(dialogue)
	

func deselect():
	if canGo and dialogue.size() > 0:
		Global.dialogue.close()
