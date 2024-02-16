extends Area2D

var timer = 0

func _ready():
	set_process(false)

func _on_SmokeyBoi_body_entered(body):
	if "Player" in body.get_name():
		set_process(true)
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(Global.camera, "zoom", Global.camera.zoom, Vector2(3, 3), 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		tween.start()

func _process(delta):
	timer += delta
	Global.player.motion += (global_position - Global.player.global_position).normalized() * 10
	Global.player.rotation = sqrt(timer)
	Global.camera.Delta -= delta * 2
	Global.camera.shake(0.5, 0.8, 0.2, 0.2)
