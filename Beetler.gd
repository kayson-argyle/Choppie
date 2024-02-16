extends Enemy

export var speed = 30
var damageTimer = 0.1
var canDamagePlayer = false

func _process(delta):
	apply_central_impulse(Vector2(sign(Global.player.global_position.x - global_position.x) * 3, 0 ))
	$Sprite.scale.x = sign(Global.player.global_position.x - global_position.x)
	if linear_velocity.x > speed:
		linear_velocity.x = speed
	if linear_velocity.x < -speed:
		linear_velocity.x = -speed
	if canDamagePlayer:
		damageTimer -= delta
		if damageTimer <= 0:
			Global.player.damage(50)
			damageTimer = 0.75


func _on_Damage_body_entered(body):
	if body.name == "Player":
		canDamagePlayer = true
		

func _on_Damage_body_exited(body):
	if body.name == "Player":
		canDamagePlayer = false
		damageTimer = 0.75
