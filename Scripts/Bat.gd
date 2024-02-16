extends Enemy

onready var squeakTimer = -1

func _process(delta):
	$Sprites.rotation_degrees = linear_velocity.x / 5
	squeakTimer -= delta
	if squeakTimer < 0:
		squeakTimer = random.randf_range(0, 17)
		if random.randi_range(0, 1) == 1:
			Sounds.playSound("res://bat1.wav")
		else:
			Sounds.playSound("res://bat2.wav")

func death():
	$MoneyExplosion.explode()
	.death()
	
