extends Npc


var attack = false
var dialogueNum = null
var talkingLoop = false
var xSpeed = 0
var startTheMadness = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.dialogue.connect("optionPicked", self, "optionSelected")
	Global.dialogue.connect("closed", self, "closed")

func optionSelected(button, _dialogueNum):
	if button == 1:
		messageName = "Engarde"
		Global.dialogue.open(data[npcName][messageName], false)
		attack = true
		
		
	if button == 2:
		messageName = "Offer"
		Global.dialogue.open(data[npcName][messageName], false)

func action():
	if attack:
		canTalk = false
		$AnimationPlayer2.play("Run")
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(self, "xSpeed", 0, -70, 2)
		tween.start()
		yield(get_tree().create_timer(8.5), "timeout")
		startTheMadness = true
		xSpeed = 0
		
	
	
func _process(delta):
	position.x += xSpeed * delta

func closed():
	if messageName == "Offer":
		loadNum = true
		messageName = "Camp"
		loadedNum = 14

func _on_QuestDude_dialogueData(num, _message):
	dialogueNum = num

