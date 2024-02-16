extends Node2D

func _process(_delta):
	if $FatBeard.waitTime > 0:
		$"../FBAnim".play("FBIdle")
	else:
		$"../FBAnim".play("FBWalk")
