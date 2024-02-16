extends Particles2D

func _ready():
	emitting = true
	Global.player.heal(50)
	global_position = Global.player.global_position + Vector2(0, -5)
	yield(get_tree().create_timer(2.0), "timeout")
	call_deferred("queue_free")
