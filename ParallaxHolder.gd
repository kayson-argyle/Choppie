extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = position * get_parent().get_parent().scroll_base_scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
