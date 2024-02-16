extends AnimationPlayer

func _ready():
	Music.playMusic("res://blackout.ogg")

func _on_Blackout_animation_finished(anim_name):
	get_tree().change_scene("res://Tutorial.tscn")
