extends Enemy

onready var initPos = global_position
var toPos = initPos
var r = RandomNumberGenerator.new()
var dir = 0
onready var anim = $Sprite/AnimationPlayer
export var maxDist = 15
var accel = 20
var state
var idleTimer = 0
var canShank = false
var maxSpeed = 20
var lv = Vector2(10, 0)
var inSight = false
var jumpTimer = 0

enum {run, idle, shank, throw}

func _ready():
	r.randomize()
	newPos()

func newPos():
	toPos = initPos + Vector2(r.randf_range(-maxDist/3, maxDist/3) + r.randf_range(-maxDist/3, maxDist/3) + r.randf_range(-maxDist/3, maxDist/3), 0)
	dir = sign(toPos.x - global_position.x)
	state = run

func _physics_process(delta):
	jumpTimer = jumpTimer - delta
	inSight = false
	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider().name == "Player":
			state = shank
			inSight = true
			if jumpTimer < 0:
				set_applied_force(Vector2(applied_force.x, -500))
				jumpTimer = 4
			
	if $RayCast2D2.is_colliding():
		if $RayCast2D2.get_collider().name == "Player":
			state = shank
			inSight = true
			if jumpTimer < 0:
				set_applied_force(Vector2(applied_force.x, -500))
				jumpTimer = 2
			
	if not inSight and state == shank:
		state = idle
		idleTimer = r.randf_range(0.5, 2)

	match state:
		run:
			if anim.current_animation != "Run":
				anim.play("Run")
			set_applied_force(Vector2(dir * accel, 0))
			
			if dir == 1 and global_position.x > toPos.x:
				state = idle
				idleTimer = r.randf_range(0.5, 2)
			if dir == -1 and global_position.x < toPos.x:
				state = idle
				idleTimer = r.randf_range(0.5, 2)
			
		idle:
			set_applied_force(-linear_velocity * 5)
			if linear_velocity.length() < 2 and anim.current_animation != "Idle":
				anim.play("Idle")
			idleTimer -= delta
			if idleTimer <= 0:
				newPos()
		shank:
			if canShank:
				if anim.current_animation != "Shank":
					anim.play("Shank")
			else:
				if anim.current_animation != "Run":
					anim.play("Run")
				set_applied_force(Vector2(sign(Global.player.global_position.x - global_position.x) * 50, applied_force.y))
			

	if linear_velocity.x != 0 and linear_velocity.length() > 2:
		if state != shank:
			$Sprite.scale.x = -sign(linear_velocity.x)
		else:
			$Sprite.scale.x = -sign(sign(Global.player.global_position.x - global_position.x))

func death():
	.death()
	$MoneyExplosion.explode()


func doShank():
	if canShank:
		Global.player.damage(50)

func _on_Shank_body_entered(body):
	if body.name == "Player":
		canShank = true


func _on_Shank_body_exited(body):
	if body.name == "Player":
		canShank = false
