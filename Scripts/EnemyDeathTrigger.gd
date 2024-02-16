extends Node2D

class_name EnemyDeathTrigger

signal allDead

var go = true

func _process(_delta):
	if get_child_count() == 0 and go:
		emit_signal("allDead")
		go = false



