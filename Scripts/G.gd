extends Node2D

func _process(_delta):
	if $Green.waitTime > 0:
		$"../GAnim".play("GIdle")
	else:
		$"../GAnim".play("GWalk")
