extends Node

var interactables = []
var selected
var backSelected

func register(node):
	if not node in interactables:
		interactables.append(node)

func select(node):
	backSelected = selected
	selected = node
	for i in interactables:
		if is_instance_valid(i):
			i.active = false
			if i.has_node("Outline"):
				i.get_node("Outline").visible = false
			i.deselect()
	selected.active = true
	selected.select()
	if selected.has_node("Outline"):
		selected.get_node("Outline").visible = true

func deselect(node):
	if node == selected:
		selected.active = false
		selected.deselect()
		if selected.has_node("Outline"):
			selected.get_node("Outline").visible = false
		selected = null
		if backSelected != null:
			selected = backSelected
			backSelected = null
			selected.active = true
			selected.select()
			if selected.has_node("Outline"):
				selected.get_node("Outline").visible = true
	if node == backSelected:
		backSelected = null

func reset():
	interactables = []

func interact():
	if selected != null:
		selected.interact()
