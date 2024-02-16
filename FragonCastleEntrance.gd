extends Sprite

var gateDown = false

func _on_Area2D_body_entered(body):
	if "Player" in body.name and not gateDown and WorldVars.openGate:
		$Gate/AnimationPlayer.play("Fall")
		gateDown = true


func _on_Area2D2_body_entered(body):
	if "Player" in body.name and not gateDown:
		$Gate/AnimationPlayer.play("Fall")
		gateDown = true
		WorldVars.openGate = true
