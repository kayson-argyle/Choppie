extends CheckBox



func _on_MuteButton_toggled(button_pressed):
	Music.mute(button_pressed)
