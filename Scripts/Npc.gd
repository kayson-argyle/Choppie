extends Sprite
class_name Npc

export var areaSize = 45
export var speed = 10
export var wander = 2
export var minWait = 1.0
export var maxWait = 3.0
export var walk = true
export var customAnim = false
var Delta = 0
var pauseForPlayer = false


var direction = 0
var random = RandomNumberGenerator.new()
var setDestination = true
var destination = 0
var waitTime = 0
var startX
export var npcName = ""
var talking = false
var dialogueNumber = 0
var data
export var expression = 0
var inArea = false
var justStoppedTalking = false
export var messageName = "Greeting"
var active
var saveExpression = 0
var loadedNum = 0
var loadNum = false
export var canTalk = true
var hasDestination = false
var actionDestination = 0
var actionOrigin = 0
var returnToOrigin = true

enum expressions {NONE, EXCLAMATION, QUESTION, COMMENT}

onready var dialogueBox = get_tree().get_current_scene().find_node("Dialogue")

signal dialogueData(num, message)

func _ready():
	deselect()
	random.randomize()
	startX = global_position.x
	Interact.register(self)
	var file = File.new()
	file.open("res://Data/Dialogue.json", File.READ)
	var text = file.get_as_text()
	file.close()
	data = parse_json(text)
	
func _process(delta):
	if hasDestination:
		direction = sign(actionDestination - actionOrigin)
		global_position.x += direction * speed * delta
		if global_position.x * direction >= actionDestination * direction:
			hasDestination = false
			canTalk = true
			arrivedDestination()
			return
	if not returnToOrigin:
		return
	if setDestination:
		for _i in range(wander):
			destination = random.randi_range($Node/LeftBound.global_position.x, $Node/RightBound.global_position.x)
		direction = sign(destination - global_position.x)
		waitTime = random.randf_range(minWait, maxWait)
		setDestination = false
		
	if (global_position.x) * direction >= destination * direction  && direction != 0:
		setDestination = true
	
	if talking:
		waitTime = random.randf_range(minWait, maxWait)
		if Input.is_action_just_pressed("ui_down"):
			dialogueNumber += 1
	

			
	justStoppedTalking = false
	
	
	if walk:
		Delta = delta
	else:
		Delta = 0
	

	
	
	if waitTime > 0:
		waitTime -= Delta
		if not customAnim:
			$AnimationPlayer.play("Idle")
	
	elif waitTime < 0:
		waitTime = 0
		if not customAnim:
			$AnimationPlayer.play("Idle")
	
	elif pauseForPlayer:
		waitTime = 1
		if not customAnim:
			$AnimationPlayer.play("Idle")
	
	else:
		global_position.x += direction * speed * delta
		if not customAnim:
			$AnimationPlayer.play("Run")
		
	if expression > 0 and canTalk:
		$Expressions.frame = expression - 1
		$Expressions.visible = true
	else: 
		$Expressions.visible = false


	
	
func interact():
	if canTalk:
		if not loadNum:
			if not talking:
				if npcName in data.keys():
					Global.dialogue.open(data[npcName][messageName], true, 0, true, messageName)
					talking = true
					emit_signal("dialogueData", Global.dialogue.dialogueNum, messageName)
				
			else:
				if Global.dialogue.next() == "closing":
					talking = false
					emit_signal("dialogueData", Global.dialogue.dialogueNum, messageName)
					action()
		else:
			if !talking:
				if npcName in data.keys():
					Global.dialogue.open(data[npcName][messageName], true, loadedNum, true, messageName)
					talking = true
					emit_signal("dialogueData", Global.dialogue.dialogueNum, messageName)
					loadNum = false
		
func action():
	pass

func goTo(xPos, var rto = true):
	canTalk = false
	hasDestination = true
	actionDestination = xPos
	$AnimationPlayer.play("Run")
	expression = 1
	actionOrigin = global_position.x
	returnToOrigin = rto

func arrivedDestination():
	pass

func stopAction():
	pass

func _on_Area2D_body_entered(body):
	if "Player" in body.get_name():
		pauseForPlayer = true
		Interact.select(self)


func _on_Area2D_body_exited(body):
	if "Player" in body.get_name():
		pauseForPlayer = false
		Interact.deselect(self)
		if talking:
			Global.dialogue.close()
			talking = false

func select():
	expression = saveExpression

func deselect():
	if expression != 0:
		saveExpression = expression
	expression = 0
