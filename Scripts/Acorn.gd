extends Projectile

func playHitSound():
	var random = RandomNumberGenerator.new()
	random.randomize()
	Sounds.playPosSound("res://click.wav", global_position, 200, -5)

