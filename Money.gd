extends RigidBody2D

export var value = 1
var bounceCounter = 0
var timer = 0
var active = false
var collisionExclusion = null
var random = RandomNumberGenerator.new()
var timeLimit = random.randf_range(10.0, 11.0)
var move = false
var initDist

func _ready():
	random.randomize()
	timeLimit = random.randf_range(10.0, 11.0)

func _process(delta):
	if active:
		timer += delta
		if timer > timeLimit:
			queue_free()
	if move:
		var lerpAmount = 35 * delta
		lerpAmount = clamp(lerpAmount, 0, 1)
		global_position = lerp(global_position, Global.player.global_position + Vector2(0, -7), lerpAmount)
		var dist = (Global.player.global_position + Vector2(0, -7) - global_position).length()
		$Sprite.scale = Vector2(dist/initDist, dist/initDist)
		$Sprite.scale.x = clamp($Sprite.scale.x, 0, 1)
		$Sprite.scale.y = clamp($Sprite.scale.y, 0, 1)
		if $Sprite.scale.x < 0.2:
			Global.changeMoneyAmount(value)
			queue_free()


func turnOn():
	print("turn on")
	$CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D2.disabled = false
	$Sprite.visible = true
	mode = MODE_CHARACTER
	active = true


func disable():
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D2.disabled = true
	$Sprite.visible = false
	mode = MODE_STATIC
	


func _on_Area2D_body_entered(body):
	print(bounceCounter)
	print(mode)
	if body != collisionExclusion:
		bounceCounter += 1
		if bounceCounter == 4:
			mode = MODE_STATIC
			bounce = 0
			gravity_scale = 0
			collision_mask = 0
			sleeping = true
			linear_velocity = Vector2(0, 0)
			linear_damp = 100


func _on_Area2D_area_entered(area):
	if "Item Pick" in area.name:
		move = true
		collision_layer = 0
		collision_mask = 0
		initDist = (Global.player.global_position + Vector2(0, -7) - global_position).length()
		if initDist == 0:
			initDist = 0.01
