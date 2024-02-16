extends KinematicBody2D

onready var tree = get_node("/root/World/Sizeable Oak")
onready var camera = get_node("/root/World/Player/Camera2D")
onready var score = get_node("/root/World/Player/Camera2D/Score")
var direction = 0
var speed = 200
var motion = Vector2.ZERO
var health = float(1000)
var velocity = 0

func _ready():
	direction = sign(position.x - tree.position.x)
	$AnimationPlayer.play("Bounce")
	


func _physics_process(delta):
	motion.x = speed * delta
#	motion.y += 300 * delta
	
	motion = move_and_slide(motion, Vector2.UP)
#more complex ai


#var motion = Vector2.ZERO
#const GRAVITY = -300
#const SPEED = 30
#const WALK_FREQ = 0.2
#var goX = 0
#var direction = 0
#var random = RandomNumberGenerator.new()
#
#func _ready():
#	random.randomize()
#	direction = random.randi_range(-1, 1)
#
#func _physics_process(delta):
#	motion.y += 300
#	goX = random.randf()
#	if goX < WALK_FREQ * delta:
#		direction = random.randi_range(-1, 1)
#	motion.x = direction * SPEED
#	motion = move_and_slide(motion, Vector2.UP)


func _on_Area2D_area_entered(area):
	if "Pick Up" in area.get_name():
		var acorn = area.get_parent()
		velocity = sqrt(pow((acorn.speedCalc2.x - acorn.speedCalc1.x) * acorn.Delta, 2) + pow((acorn.speedCalc2.y - acorn.speedCalc1.y) * acorn.Delta, 2)) * 10000
		health -= velocity
		acorn.destroy()
		modulate = Color(10,10,10,10)
		camera.shake(0.5, 0.8, 0.1, 2)
		yield(get_tree().create_timer(0.05), "timeout")
		modulate = Color(1,1,1,1)
		if health <= 0:
			Global.score += 1000
			queue_free()
		
