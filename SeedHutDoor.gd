extends Door

func interact():
	.interact()
	if inside:
		yield(get_tree().create_timer(animationTime), "timeout")
		get_parent().get_node("InsideForeground").z_index = 5
		for i in get_parent().get_node("Items").get_children():
			i.canInteract = true
		$"../Roof".collision_layer = 0
		$"../Roof".collision_mask = 0
	else:
		get_parent().get_node("InsideForeground").z_index = 0
		for i in get_parent().get_node("Items").get_children():
			i.canInteract = false
		$"../Roof".collision_layer = 7
		$"../Roof".collision_mask = 7
