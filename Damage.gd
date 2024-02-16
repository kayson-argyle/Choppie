extends Area2D

export var damage = 100.0
export var shakeIntensity = 5
export var shakeDuration = 0.1
var canDamage = true


signal hit

func _on_Damage_body_entered(body):
	if body.get_name() == "Player" and canDamage:
		Global.player.damage(damage)
		Global.camera.shake(0.05, 10, shakeDuration, shakeIntensity)
		emit_signal("hit")
