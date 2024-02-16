extends Sprite

enum {
	idle,
	charge,
	rear
}

var state = idle
export var direction = -1
var velocity = 0
var acceleration = 70
var maxSpeed = 150
var health = 400
var initHealth = health
var closeDist = 50
export var pos = "r"
var timer = 0
var sped = 0
var defeated = false
export var finishX = 0
export var finishDir = 1
var initDistFromFinish = 0
var r = RandomNumberGenerator.new()
onready var haha = r.randomize()

signal damage (healthLeft)

func _process(delta):
	timer += delta
	$Left/Position2D.position.x += sin(timer) * 50 * delta
	$Right/Position2D.position.x += cos(timer) * 50 * delta
	$Lance/Sprite2/Speed.emitting = false
	if defeated: 
		
		direction = sign(finishX - position.x)
		
		velocity += acceleration * delta * direction
		velocity = clamp(velocity, -maxSpeed, maxSpeed)
		position.x += velocity * delta * clamp(abs(finishX - position.x) / initDistFromFinish, 0.1, 1)
		
		scale.x = -sign(velocity)
		if position.x > finishX - 1 and position.x < finishX + 1:
			scale.x = finishDir
			acceleration = 0
			velocity = 0
			
			if $AnimationPlayer.current_animation != "Idle":
				$AnimationPlayer.play("Idle")
		elif $AnimationPlayer.current_animation != "Run":
			$AnimationPlayer.play("Run")
		
			
			
		return
	match state:
		idle:
			$LanceRot.look_at($LanceRot.global_position + Vector2(0, -1))
			if $AnimationPlayer.current_animation != "Idle":
				$AnimationPlayer.play("Idle")
				sped = delta * 3
		charge:
			$LanceRot.look_at(Global.player.global_position + Vector2(0, -7))
			velocity += acceleration * delta
			velocity = clamp(velocity, 0, maxSpeed)
			position.x += direction * velocity * delta
			if $AnimationPlayer.current_animation != "Run":
				$AnimationPlayer.play("Run")
			if global_position.x < $Left/Position2D.global_position.x and pos != "l":
				pos = "l"
				state = rear
				velocity = 0
				scale.x = -1
				direction = 1
			if global_position.x > $Right/Position2D.global_position.x and pos != "r":
				pos = "r"
				state = rear
				velocity = 0
				scale.x = 1
				direction = -1
			var normAngle = Vector2(cos($Lance.rotation), sin($Lance.rotation)).angle()
			if rad2deg(normAngle) < 202.5 and rad2deg(normAngle) > 157.5 and velocity > 20:
				$Lance/Sprite2/Speed.emitting = true
			sped = delta * 8
		rear:
			$LanceRot.look_at($LanceRot.global_position + Vector2(-1 * scale.x, 1))
			if $AnimationPlayer.is_playing() == false:
				state = charge
			elif not "Rear" in $AnimationPlayer.current_animation:
				$AnimationPlayer.play("Rear" + str(r.randi_range(1, 3)))
			sped = delta * 3
		
	
	sped = clamp(sped, 0, 1)
	$Lance.rotation = lerp($Lance.rotation, $LanceRot.rotation, sped)


func ouchie(area):
	health -= area.get_parent().get_damage()
	Global.camera.shake(0.3, 0.8, 0.3, area.get_parent().get_damage())
	area.get_parent().destroy()
	if health <= 0:
		health = 0
		defeated = true
		$Lance/Sprite2/Destruction.emitting = true
		$Lance/Sprite2.self_modulate.a = 0
		$Lance/Sprite2/Speed.modulate.a = 0
		initDistFromFinish = abs(finishX - position.x)
		velocity *= direction
	emit_signal("damage", health)


func _on_Hitbox_area_entered(area):
	if not defeated:
		if "SeedCollision" in area.get_name():
			ouchie(area)
		if "SeedTrigger" in area.get_name():
			area.get_parent().trigger()


func _on_Area2D_body_entered(body):
	if "Player" == body.name and not defeated:
		Global.player.launch(Vector2(300 * direction, -128))
		Global.cameraShake(0.3, 0.8, 0.6, 30)
		Global.player.damage(150)
		Sounds.playPosSound("res://kerthwack.wav", global_position, 100, 10)
