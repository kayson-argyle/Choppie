extends Interactable

class_name Door

export var animationTime = 1
export var zoom = 1.0
export var inside = false
var tween = Tween.new()
var interacting = false

func _ready():
	add_child(tween)

func interact():
	if not interacting:
		interacting = true
		if not inside:
			inside = true
			Sounds.playPosSound("res://doorOpen.wav", global_position)
			get_parent().get_node("StaticBody2D").collision_layer = 23
			get_parent().get_node("StaticBody2D").collision_mask = 23
			tween.interpolate_property(self, "self_modulate", modulate, Color(0.5,0.5, 0.5, 0.5), animationTime, Tween.TRANS_CIRC, Tween.EASE_IN)
			tween.interpolate_property(self, "scale:x", 1, 0, animationTime, Tween.TRANS_CIRC, Tween.EASE_IN)
			tween.interpolate_property(Global.camera, "zoom", Vector2(1, 1), Vector2(zoom, zoom), animationTime * 1.5, Tween.TRANS_BACK, Tween.EASE_IN)
			tween.interpolate_property(get_parent().get_node("BuildingOutside"), "modulate:a", 1, 0, animationTime, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			for i in $"../Seeds".get_children():
				i.activate()
		else:
			Sounds.playPosSound("res://doorClose.wav", global_position)
			inside = false
			z_index = 1
			get_parent().get_node("StaticBody2D").collision_mask = 16
			get_parent().get_node("StaticBody2D").collision_layer = 16
			tween.interpolate_property(self, "self_modulate", modulate, Color(1, 1, 1, 1), animationTime, Tween.TRANS_CIRC, Tween.EASE_IN)
			tween.interpolate_property(self, "scale:x", 0, 1, animationTime, Tween.TRANS_CIRC, Tween.EASE_OUT)
			tween.interpolate_property(Global.camera, "zoom", Vector2(zoom, zoom), Vector2(1, 1), animationTime * 1.5, Tween.TRANS_BACK, Tween.EASE_IN)
			tween.interpolate_property(get_parent().get_node("BuildingOutside"), "modulate:a", 0, 1, animationTime, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			for i in $"../Seeds".get_children():
				active = false
		tween.start()
		yield(get_tree().create_timer(animationTime * 1.5), "timeout")
		if inside:
			z_index = 6
		scale.x = 1
		interacting = false

