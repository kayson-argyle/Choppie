extends Node2D

var tween = Tween.new()
var addTween = true

func light():
	if addTween:
		addTween = false
		add_child(tween)
	for i in get_children():
		if i.has_node("Particles2D"):
			if i.get_node("Particles2D").emitting == false:
				i.get_node("Particles2D").emitting = true
				Sounds.playPosSound("res://breathFire.wav", i.global_position, 300, 0, 0, 1.5)
				tween.interpolate_property(i.get_node("TorchLight").get_material(), "shader_param/brightness", 0, 0.5, 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
				tween.start()
				yield(get_tree().create_timer(0.5), "timeout")
				


func _on_Area2D_body_entered(body):
	if "Player" == body.get_name():
		light()
