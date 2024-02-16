tool
extends Sprite

var dialogue = []
var dialogueNum = 0
var closed = true
signal optionPicked (option, num)
signal closed
var animDir = "forward"
var arrow = false
var arrowPos = 0
var messageName

func _ready():
	open({ "0" : "yee", "1": "yooo", "2" : "yeet"}, false)
	setNum(2)
	
func _process(delta):
	if arrow:
		arrowPos += delta
		$Scale/Arrow.offset.y = sin(arrowPos * 6) * 5

func open(text, anim : bool = true, var num = 0, var enableArrow = true, var mesName = ""):
	messageName = mesName
	if anim:
		closed = false
	dialogueNum = num
	dialogue = text
	arrow = false
	$Scale/Arrow.visible = false
	if not dialogue.has("no arrow") and enableArrow:
		if dialogue.size() > dialogueNum:
			arrow = true
			$Scale/Arrow.visible = true
		else:
			arrow = false
			$Scale/Arrow.visible = false
	if anim:
		animDir = "forward"
		$AnimationPlayer.play("Open")
	if typeof(dialogue[str(dialogueNum)]) == TYPE_DICTIONARY:
		$Scale/Options.visible = true
		$Scale/Options/Option1.text = dialogue[str(dialogueNum)]["1"]
		$Scale/Options/Option2.text = dialogue[str(dialogueNum)]["2"]
		$Scale/Text.set_text(dialogue[str(dialogueNum)]["text"])
		return
	$Scale/Text.set_text(dialogue[str(dialogueNum)])
	$Scale/Options.visible = false
	
	
func close():
	if not closed:
		animDir = "backward"
		$AnimationPlayer.play_backwards("Open")
		dialogueNum = 0
		closed = true
	
func setText(text):
	dialogue = text
	$Scale/Text.set_text(dialogue[str(dialogueNum)])
	
func next(var override: bool = false):
	
	if (not $AnimationPlayer.is_playing() and not $Scale/Options.visible) or override:
		dialogueNum += 1
		arrow = false
		$Scale/Arrow.visible = false
		if not dialogue.has("no arrow"):
			if dialogue.size() > dialogueNum + 1:
				arrow = true
				$Scale/Arrow.visible = true
			else:
				arrow = false
				$Scale/Arrow.visible = false
		if dialogueNum < len(dialogue):
			if typeof(dialogue[str(dialogueNum)]) == TYPE_DICTIONARY:
				$Scale/Options.visible = true
				$Scale/Options/Option1.text = dialogue[str(dialogueNum)]["1"]
				$Scale/Options/Option2.text = dialogue[str(dialogueNum)]["2"]
				$Scale/Text.set_text(dialogue[str(dialogueNum)]["text"])
				return
			if not dialogue[str(dialogueNum)] == "no arrow":
				$Scale/Text.set_text(dialogue[str(dialogueNum)])
				$Scale/Options.visible = false
	
		else:
			close()
			return "closing"
		if closed:
			animDir = "forward"
			$AnimationPlayer.play("Open")
	
func setNum(num):
	dialogueNum = num
	if typeof(dialogue[str(dialogueNum)]) == TYPE_DICTIONARY:
		$Scale/Options.visible = true
		$Scale/Options/Option1.text = dialogue[str(dialogueNum)]["1"]
		$Scale/Options/Option2.text = dialogue[str(dialogueNum)]["2"]
		$Scale/Text.set_text(dialogue[str(dialogueNum)]["text"])
		return
	$Scale/Text.set_text(dialogue[str(dialogueNum)])
	$Scale/Options.visible = false
	


func _on_Option1_pressed():
	emit_signal("optionPicked", 1, dialogueNum)


func _on_Option2_pressed():
	emit_signal("optionPicked", 2, dialogueNum)


func _on_AnimationPlayer_animation_finished(_anim_name):
	if animDir == "backward":
		emit_signal("closed")


