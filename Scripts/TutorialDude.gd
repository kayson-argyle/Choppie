extends Npc

func _ready():
	$"../Player/CameraHolder/Camera2D".shakeOffset = Vector2(0, -20)
	

func _on_EnemyDeathTrigger_allDead():
	messageName = "Gratitude"
	expression = expressions.EXCLAMATION

func action():
	if messageName == "Greeting":
		expression = expressions.COMMENT
		messageName = "Help"
	if messageName == "Gratitude":
		expression = expressions.NONE
		messageName = "Leave"
	
