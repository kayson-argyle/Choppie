extends AnimationPlayer



func _on_Bonk_animation_finished(_anim_name):
	get_tree().change_scene("res://Blackout.tscn")
