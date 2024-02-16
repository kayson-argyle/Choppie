extends Particles2D

var onGround = false
var anim = ""

func _on_AnimationPlayer_animation_started(anim_name):
	anim = anim_name
	if anim == "Run" and onGround:
		emitting = true
	else:
		emitting = false



func _on_Player_onGround(boolean):
	onGround = boolean
	if anim == "Run" and onGround:
		emitting = true
	else:
		emitting = false
	
