extends TreeBoi

var timer = 0
var dialogueOpen = false
var r = RandomNumberGenerator.new()
var otherTimer = 0
var prevR = -1
var displayTime = 1.5
var rRoll = 0

func _process(delta):
	timer += delta
	if timer > displayTime + 1 and dialogueOpen:
		Global.dialogue.close()
		dialogueOpen = false
	if dialogueOpen and otherTimer != 0:
		otherTimer += delta
		if otherTimer > displayTime:
			otherTimer = 0

func action():
	if otherTimer == 0:
		otherTimer = 0.01
		timer = 0
		if rRoll != prevR:
			if rRoll == 0:
				Global.dialogue.open({"0" : "Oi!"}, not dialogueOpen, 0, false)
				displayTime = 1.5
			elif rRoll == 1:
				Global.dialogue.open({"0" : "Don't ya dare throw ya acorns at the rock under the waterfall!"}, not dialogueOpen, 0, false)
				displayTime = 3
			elif rRoll == 2:
				Global.dialogue.open({"0" : "Cut that out!"}, not dialogueOpen, 0, false)
				displayTime = 1.5
			elif rRoll == 3:
				Global.dialogue.open({"0" : "Take off, ya hoser!"}, not dialogueOpen, 0, false)
				displayTime = 1.5
			elif rRoll == 4:
				Global.dialogue.open({"0" : "Gecher axe out of me wood!"}, not dialogueOpen, 0, false)
				displayTime = 1.5
			dialogueOpen = true
			Sounds.playPosSound("res://willowGrunt.wav", global_position)
			rRoll += 1
			if rRoll == 5:
				rRoll = 0
		else:
			otherTimer == 0 
			action()
	
func _on_Area2D_area_exited(area):
	._on_Area2D_area_exited(area)
	Global.dialogue.close()
	dialogueOpen = false
	otherTimer = 0
	prevR = -1

func _ready():
	pass
