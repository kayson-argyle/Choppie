extends Node2D

onready var beetle = preload("res://Beetle.tscn")

func _ready():
	var enemy = beetle.instance()
	add_child(enemy)

func _on_Timer_timeout():
	var enemy = beetle.instance()
	add_child(enemy)
	$Timer.wait_time *= 0.98

