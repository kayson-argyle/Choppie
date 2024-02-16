extends Projectile

var boomerang = false
var pathSize = 17
var pathTimer = 0
var initPos
var speed = 5000
var pathPos
var rotSpeed = 8
var canGo = true

func onThrow():
	initPos = global_position
	boomerang = true
	

func _process(delta):
	if canGo:
		$Node2D/Sprite.rotation += delta * rotSpeed * PI
		if boomerang:
		
			global_position = initPos + Vector2(cos(angle), sin(angle)) * speed * delta * (-pow(pathTimer - sqrt(0.5),2) + 0.5)
			pathTimer += delta
				
			if pathTimer > 0.5:
				boomerang = false
				call_deferred("changeMode", RigidBody2D.MODE_RIGID)
		else:
			apply_central_impulse((Global.player.global_position + Vector2(0, -7) - global_position) * 0.4)


func _on_Bump_body_entered(body):
	
	if body.name != "Player" and not "BatWing" in body.name:
		collision_layer = 2
		collision_mask = 2
		rotSpeed = 0
		canGo = false
		call_deferred("changeMode", RigidBody2D.MODE_RIGID)
		gravity_scale = 1


func changeMode(m):
	mode = m

func _on_Bump_area_entered(area):
	if pathTimer > 0 and area.get_name() == "Item Pick" and not boomerang:
		if Global.changeItemAmount("BatWing", 1):
			queue_free()
