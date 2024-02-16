extends Travel

var interacting = false
var tween = Tween.new()
export var animationTime = 1
export var toDoorId = ""
export var id = ""

func _ready():
	add_child(tween)
	if Global.doorId == id:
		self_modulate = Color(0.5, 0.5, 0.5, 0.5)
		scale.x = 0
		Sounds.playPosSound("res://doorClose.wav", global_position)
		tween.interpolate_property(self, "self_modulate", self_modulate, Color(1, 1, 1, 1), animationTime, Tween.TRANS_CIRC, Tween.EASE_IN)
		tween.interpolate_property(self, "scale:x", 0, 1, animationTime, Tween.TRANS_CIRC, Tween.EASE_IN)
		tween.start()
		

func interact():
	if not interacting:
		interacting = true
		tween.stop_all()
		Sounds.playPosSound("res://doorOpen.wav", global_position)
		tween.interpolate_property(self, "self_modulate", self_modulate, Color(0.5, 0.5, 0.5, 0.5), animationTime, Tween.TRANS_CIRC, Tween.EASE_IN)
		tween.interpolate_property(self, "scale:x", 1, 0, animationTime, Tween.TRANS_CIRC, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		if canGo:
			Global.changeScene(toScene, 1, setPostion, toPosition, toDoorId)
