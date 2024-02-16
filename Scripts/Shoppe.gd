extends TextureRect

var cartAmount = 0

func _ready():
	Global.register("shoppe", self)

func open():
	if !$"../".find_node("Inventory").visible:
		$"../".find_node("Inventory").open()
	if !visible:
		visible = true
		var children = get_children()
		for child in children:
			if "InventoryPoint" in child.get_name():
				child.set_deferred("monitorable", visible)

func close():
	visible = false
	var children = get_children()
	for child in children:
		if "InventoryPoint" in child.get_name():
			child.set_deferred("monitorable", false)

func _on_TextureButton_pressed():
	close()


func _on_Up_button_down():
	updateCart(cartAmount + 1)

func _on_Down_button_down():
	updateCart(cartAmount - 1)

func _on_Purchase_button_down():
	
	if $InventoryPoint17.get_child_count() == 2 and cartAmount > 0:
		var boughtItem = $InventoryPoint17/Item
		for child2 in $"../Inventory".get_children():
			if "InventoryPoint" in child2.get_name():
				if child2.has_node("Item"):
					if child2.get_node("Item").frame == 1 and child2.get_node("Item").amount >= cartAmount:
						for child in $"../Inventory".get_children():
							if "InventoryPoint" in child.get_name():
								if child.has_node("Item"):
									if child.get_node("Item").frame == boughtItem.frame:
										child.get_node("Item").setAmount(child.get_node("Item").amount + cartAmount)
										updateCart(0)
										$InventoryPoint17.remove_child(boughtItem)
										for child3 in get_children():
											if "InventoryPoint" in child3.get_name():
												if !child3.has_node("Item"):
													child3.add_child(boughtItem)
													boughtItem.position = Vector2(0, 0)
													return
										return
									
						for child in $"../Inventory".get_children():
							if !child.has_node("Item"):
								child2.get_node("Item").setAmount(child2.get_node("Item").amount - cartAmount)
								$InventoryPoint17.remove_child(boughtItem)
								var bought2 = boughtItem.duplicate()
								child.add_child(boughtItem)
								boughtItem.position = Vector2(0, 0)
								boughtItem.type = "Player"
								boughtItem.setAmount(cartAmount)
								updateCart(0)
								$"../HBoxContainer".updateSprites()
								for child3 in get_children():
									if "InventoryPoint" in child3.get_name():
										if !child3.has_node("Item"):
											child3.add_child(bought2)
											bought2.position = Vector2.ZERO
											return
								return
		
		
func updateCart(amount):
	if $InventoryPoint17.get_child_count() == 2:
		cartAmount = amount
		if cartAmount < 0:
			cartAmount = 0
		$"Node2D/Text".text = str(cartAmount)
	else:
		cartAmount = 0
		$"Node2D/Text".text = str(cartAmount)
