extends Camera2D

var intensity = 0
var doShake = false
var Delta = 0
var length = 0
var speed = 0
var lockPos = false
var nextPos = Vector2(0, 0)
var unlockedPos = Vector2(0, 0)
var mouseTimer = 0
export var shakeOffset = Vector2.ZERO
export var height = 7

var noise = OpenSimplexNoise.new()
var random = RandomNumberGenerator.new()

onready var player = get_parent().get_parent()

func _ready():
	nextPos = player.global_position


func shake(period, persistence, time, power):
#	Period --> How quickly the screen shakes, lower is faster
#	Persistence --> How often the shake changes direction --> 0.8
#	Time --> How long the shake lasts --> 0.1
#	Power --> How violent the shakes are --> 2
	doShake = true
	random.randomize()
	noise.seed = random.randi()
	noise.octaves = 4
	noise.period = period
	noise.persistence = persistence
	length = time
	intensity = power
	
func _process(delta):
	scale = zoom
	if Input.is_action_pressed("Shift"):
		mouseTimer += delta * 3
	else:
		mouseTimer -= delta * 4
	mouseTimer = clamp(mouseTimer, 0, 1)

func _physics_process(delta):
	if doShake:
		Delta += delta
		offset.x = noise.get_noise_2d(Delta, 0) * intensity * ((length - Delta) / length)
		offset.y = noise.get_noise_2d(0, Delta) * intensity * ((length - Delta) / length)
		if Delta > length:
			doShake = false
			Delta = 0
			offset = Vector2(0, 0)
			
	calcXPos()
	calcYPos()
	unlockedPos = position
	if lockPos:
		position = nextPos + shakeOffset
	
func calcYPos():
	var mouseLook = smoothStep((get_global_mouse_position().y - Global.player.global_position.y) / 100) * 20
	position.y = player.position.y + shakeOffset.y - height + mouseLook * ss(mouseTimer)
	
func calcXPos():
	var mouseLook = smoothStep((get_global_mouse_position().x - Global.player.global_position.x) / 100) * 20
	position.x = player.position.x + shakeOffset.x + mouseLook * ss(mouseTimer)


func smoothStep(val):
	val = clamp(val, -1, 1)
	return -0.5 * pow(val, 3) + 1.5 * val
	
func ss(val):
	val = clamp(val, 0, 1)
	return 3 * pow(val, 2) - 2 * pow(val, 3)
