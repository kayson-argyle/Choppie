extends Enemy

class_name LineOfSightEnemy

export var attackDist = 50
export var stupid = true
var ray
export var attackTime = 3
var timer = 0

func _ready():
	if not stupid:
		ray = RayCast2D.new()
		add_child(ray)
		ray.enabled = true

func _process(delta):
	if (Global.player.global_position + Vector2(0, -7) - global_position).length() < attackDist:
		timer += delta
		if not stupid:
			ray.cast_to = (Global.player.global_position + Vector2(0, -7) - global_position)
		if timer > attackTime:
			if stupid:
				attack()
				timer = 0
			else:
				if ray.get_collider() != null:
					if ray.get_collider().name == "Player":
						attack()
						timer = 0
	else:
		timer -= delta
		timer = clamp(timer, 0, attackTime)

func attack():
	pass
