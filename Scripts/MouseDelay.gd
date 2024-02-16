extends Node2D

func _physics_process(_delta):
	$Sprite3.position = $Sprite2.position
	$Sprite2.position = $Sprite.position
	$Sprite.position = get_local_mouse_position()
