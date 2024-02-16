extends Sprite

class_name Interactable

var active = false
export var canInteract = true

func _ready():
	Interact.register(self)

func _on_InteractionArea_body_entered(body):
	if body.get_name() == "Player" and canInteract:
		Interact.select(self)
		
		

func _on_InteractionArea_body_exited(body):
	if body.get_name() == "Player":
		Interact.deselect(self)
		

func interact():
	pass

func select():
	pass

func deselect():
	pass
