extends AnimationPlayer

func _ready():
	var random = RandomNumberGenerator.new()
	random.randomize()
	if random.randi_range(0, 1) == 1:
		play_backwards("Pulse")
	else:
		play("Pulse")
	playback_speed = random.randf_range(0.07, 0.09)
	advance(random.randf_range(0, get_current_animation_length() / playback_speed))
	
