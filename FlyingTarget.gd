extends Enemy

onready var drop = preload("res://Seed.tscn")

func _ready():
	if visible == false:
		$Hitbox.collision_layer = 0
		$Hitbox.collision_mask = 0

func show():
	visible = true
	$Hitbox.collision_mask = 2
	collision_layer = 6
	collision_mask = 6
	$AnimationPlayer.play("Fly")

func death():
	$MoneyExplosion.explode()
	.death()
	
func hit():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var sound = "res://thump.wav" 
	Sounds.playSound(sound)
