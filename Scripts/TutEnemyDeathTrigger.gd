extends EnemyDeathTrigger

func _ready():
	for i in get_children():
		i.set_process(false)

func _on_TutorialDude_dialogueData(num, message):
	if num == 0 and message == "Greeting":
		var tween = Tween.new()
		get_parent().add_child(tween)
		tween.interpolate_property(self, "position:y", position.y, 0, 2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()
		for i in get_children():
			i.set_process(true)
