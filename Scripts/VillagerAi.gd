extends Sprite

var direction = 0
const SPEED = 10
var random = RandomNumberGenerator.new()
var setDestination = true
var destination = 0
var waitTime = 0

func _ready():
	random.randomize()

func _process(delta):
	if setDestination:
		destination = 0
		for _i in range(2):
			destination += random.randi_range(-45, 45)
		direction = sign(destination - position.x)
		waitTime = random.randi_range(1, 3)
		setDestination = false
		
	if position.x * direction >= destination * direction && direction != 0:
		setDestination = true
	
	
	if waitTime > 0:
		waitTime -= delta
	
	elif waitTime < 0:
		
		waitTime = 0
	
	else:
		position.x += direction * SPEED * delta


