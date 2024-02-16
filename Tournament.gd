extends Level

var tween = Tween.new()
var shown = [false, false, false]
var redhi = 0
var bluehi = 0
var greenhi = 0
var interpNum = 0
var healthNum = 0
var ranAgain = false

func _ready():
	add_child(tween)
	WorldVars.traveledToCamp = true
	if WorldVars.openGate:
		$QuestDude.queue_free()

func _process(_delta):
	healthNum = 0
	setHealths($Red, $Player/CameraHolder/Camera2D/CanvasLayer/Control/RedBar, "red")
	setHealths($Blue, $Player/CameraHolder/Camera2D/CanvasLayer/Control/BlueBar, "blue")
	setHealths($Green, $Player/CameraHolder/Camera2D/CanvasLayer/Control/GreenBar, "green")
	if not WorldVars.openGate:
		if $QuestDude.startTheMadness:
			if not shown[0]:
				showBar($Player/CameraHolder/Camera2D/CanvasLayer/Control/RedBar)
				$Red.direction = 1
				shown[0] = true
				tween.interpolate_property(self, "redhi", 0, 0.5, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
				tween.start()
				$Red.state = $Red.charge
			if $Red.health/$Red.initHealth < 0.66 and not shown[1]:
				showBar($Player/CameraHolder/Camera2D/CanvasLayer/Control/BlueBar)
				$Blue.direction = -1
				shown[1] = true
				tween.interpolate_property(self, "bluehi", 0, 0.5, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
				tween.start()
				$Blue.state = $Blue.charge
			if ($Blue.health/$Blue.initHealth < 0.66 or $Red.health/$Red.initHealth < 0.33) and not shown[2]:
				showBar($Player/CameraHolder/Camera2D/CanvasLayer/Control/GreenBar)
				$Green.direction = 1
				shown[2] = true
				tween.interpolate_property(self, "greenhi", 0, 0.5, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
				tween.start()
				$Green.state = $Green.charge
			if $Blue.health == 0 and $Green.health == 0 and $Red.health == 0 and not ranAgain:
				WorldVars.openGate = true
				tween.interpolate_property($QuestDude, "position:x", -300, 40, 6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				tween.start()
				ranAgain = true
				$QuestDude.scale.x = -1
				$QuestDude.messageName = "Congrats"
				yield(tween, "tween_completed")
				$QuestDude/AnimationPlayer2.play("Idle")
				$QuestDude.canTalk = true
				$QuestDude.scale.x = 1
		

func setHealths(knight, bar, color):
	var size = knight.health/knight.initHealth * get(color + "hi")
	bar.scale.x = size
	if size == 0:
		bar.size = 0
	else:
		bar.size = 0.5
	healthNum +=1
	
func showBar(bar):
	bar.visible = true
	bar.scale.x = 0
	interpNum += 1
