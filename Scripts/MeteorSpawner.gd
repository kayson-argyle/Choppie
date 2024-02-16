tool
extends Node2D

var random = RandomNumberGenerator.new()

export(float, 0, 360) var angle
export(float, 0, 1000) var speed = 100.0
export(float) var spawnRate

var meteor = preload("res://Meteors.tscn")

func _process(delta):
	if not Engine.editor_hint:
		random.randomize()
		if delta != 0:
			if floor(random.randi_range(0, spawnRate/delta)) == 0:

				var minst = meteor.instance()
				add_child(minst)
				minst.velocity = speed * Vector2(cos(deg2rad(angle + random.randf_range(-5, 5))), sin(deg2rad(angle + random.randf_range(-5, 5))))
			
