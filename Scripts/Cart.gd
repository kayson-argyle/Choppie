extends Node2D

export var type = ""
var previousCount = 0

func _process(_delta):
	if get_child_count() == 2 and previousCount == 1 or (get_child_count() == 1 and previousCount == 2 ):
		get_parent().updateCart(0)
		
	previousCount = get_child_count()
