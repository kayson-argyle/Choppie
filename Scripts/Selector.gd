extends Sprite

func _ready():
	updateSprites()

func updateSprites():
	for child in $Seeds.get_child_count():
		if $"../Inventory".get_child(child).has_node("Item"):
			$Seeds.get_child(child).frame = $"../Inventory".get_child(child).get_node("Item").frame
		else:
			$Seeds.get_child(child).frame = 0
