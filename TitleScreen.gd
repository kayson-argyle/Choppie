extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var yeet = false
var huh = false
var tween = Tween.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	yield(get_tree().create_timer(1), "timeout")
	
	add_child(tween)
	tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 1), 2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(2), "timeout")
	tween.interpolate_property($TitleScreenText, "modulate:a", 0, 1, 4, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(get_tree().create_timer(1), "timeout")
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(3), "timeout")
	set_process(true)
	huh = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if yeet:
		set_process(false)
		huh = false
		tween.interpolate_property(self, "modulate", modulate, Color(0, 0, 0, 1), 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		tween.start()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://BonkScene.tscn")
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and huh:
			yeet = true
