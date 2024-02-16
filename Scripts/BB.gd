extends Node2D

func _process(_delta):
	if $BaldBeard.waitTime > 0:
		$"../BBAnim".play("BBIdle")
		
	else:
		$"../BBAnim".play("BBWalk")
		
