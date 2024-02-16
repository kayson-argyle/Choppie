extends ColorRect

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible
		darken()
	if visible:
		get_tree().paused = true
	else:
		get_tree().paused = false

func _on_Button_button_down():
	get_tree().quit()

func _on_Button2_button_down():
	visible = false
	darken()

func darken():
	pass
	if visible:
		$"../Transition".modulate.a = 0.5
	else:
		$"../Transition".modulate.a = 0
