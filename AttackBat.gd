extends LineOfSightEnemy

onready var initialPos = global_position
var doAttack = false
var attackingTimer = 0

onready var squeakTimer = -1

func _ready():
	attackTime = 0.5

func _process(delta):
	$Sprites.rotation_degrees = linear_velocity.x / 5
	squeakTimer -= delta
	if squeakTimer < 0:
		squeakTimer = random.randf_range(0, 17)
		if random.randi_range(0, 1) == 1:
			pass
			Sounds.playPosSound("res://bat1.wav", global_position)
		else:
			pass
			Sounds.playPosSound("res://bat2.wav", global_position)
			
	if doAttack:
		apply_central_impulse((Global.player.global_position + Vector2(0, -7) - global_position).normalized() * 25)
		timer = 0
		attackingTimer += delta
		if attackingTimer > 0.6:
			doAttack = false
			initialPos = global_position
			attackingTimer = 0


func attack():
	$ShrinkShake.play("SS")
	Sounds.playPosSound("res://batcharge.wav", global_position, 250)


func _on_ShrinkShake_animation_finished(_anim_name):
	doAttack = true
	attackingTimer = 0


func _on_Damage_hit():
	doAttack = false
	initialPos = global_position
	timer = 0


func death():
	$MoneyExplosion.explode()
	.death()
