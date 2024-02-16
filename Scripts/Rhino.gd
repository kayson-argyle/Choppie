extends KinematicBody2D


export var health = 400
var attack = false
var velocity = Vector2.ZERO
var start = 0
var direction = 0
var previousPosX = 0
var drag = 0
var resetDrag = false
export var friction = 0.99
export var sleeping = false
var gravity = Global.gravity

const ACCELERATION = 80
const MAX_VELOCITY = 100

func _ready():
	$ProgressBar.rect_size = Vector2(34, 4)
	start = position.x
	$ProgressBar.max_value = health

func _process(delta):
	if attack and not sleeping:
		$Rhino.scale.x = sign(Global.player.global_position.x - global_position.x)
		$Rhino/ZZZ.scale.x = sign(Global.player.global_position.x - global_position.x)
	elif velocity.x != 0 and not sleeping:
		$Rhino.scale.x = sign(velocity.x)
		$Rhino/ZZZ.scale.x = sign(Global.player.global_position.x - global_position.x)
	previousPosX = position.x
	
	if attack:
		direction = sign(Global.player.position.x - position.x)
	
	else:
		direction = sign(start - position.x)
	if not sleeping:
		velocity.x *= friction
		velocity.x += ACCELERATION * direction * delta
		velocity.x = clamp(velocity.x, -MAX_VELOCITY, MAX_VELOCITY)
		velocity.y += gravity
		velocity = move_and_slide(velocity)
	else:
		health += 5 * delta
		$ProgressBar.value = health
		if health >= $ProgressBar.max_value:
			health = clamp(health, 0, $ProgressBar.max_value)
			sleeping = false
			$Rhino.self_modulate.b = 1
			$Rhino/AnimationPlayer.play("Run")
	
	
func _on_Rhino_Trigger_area_entered(area):
	if "Item Pick" in area.get_name():
		attack = true
		

func _on_Rhino_Trigger_area_exited(area):
	if "Item Pick" in area.get_name():
		attack = false

func _on_Area2D_body_entered(body):
	if sleeping:
		return
	if "Player" in body.get_name():
		Global.player.motion.x = 600 * $Rhino.scale.x
		Global.player.motion.y = -300
		Global.camera.shake(0.3, 0.8, 0.6, 30)
		Global.player.damage(150)
		drag = Global.player.drag
		$Rhino/Hit.emitting = true
		Global.player.drag = 0
		Sounds.playPosSound("res://kerthwack.wav", global_position, 100, 10)
		Global.player.resetDrag(0.5)
		
	


func _on_Area2D_area_entered(area):
	if "SeedCollision" in area.get_name() and not sleeping:
		$Rhino/Flash.play("Flash")
		Global.camera.shake(0.5, 0.8, 0.2, 0.2)
		var acorn = area.get_parent()
		velocity.x -=  sqrt(pow((acorn.speedCalc2.x - acorn.speedCalc1.x) * acorn.Delta, 2) + pow((acorn.speedCalc2.y - acorn.speedCalc1.y) * acorn.Delta, 2)) * 1000 * sign(velocity.x)
		health -= acorn.get_damage()
		$ProgressBar.value = health
		if health <= 0:
			$Rhino/AnimationPlayer.play("Sleep")
			sleeping = true
		acorn.destroy()


