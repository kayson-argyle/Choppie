extends Sprite

var velocity = Vector2(-110, 0)
var tween = Tween.new()

func _ready():
	add_child(tween)
	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2(3, 3), 1.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()

func _process(delta):
	position += velocity * delta

func _on_Area2D_body_entered(body):
	if "Player" in body.get_name():
		body.damage(500)
		Global.cameraShake(0.4, 5, 1.5, 22)
		Global.player.motion += Vector2(-100, -400)
		Global.player.drag = 0
		Sounds.playPosSound("res://Boom.wav", global_position, 500, 10)
		yield(get_tree().create_timer(0.5), "timeout")
		Global.player.drag = 9
	elif body.has_method("damage"):
		body.damage(1000)
		



func _on_Area2D_area_entered(area):
	if area.name == "BigBoyDetonator":
		var explosion = load("res://Explosion.tscn")
		var ei = explosion.instance()
		get_parent().add_child(ei)
		ei.global_position = $Pos.global_position
		ei.scale = Vector2(2, 2)
		$"../../KillFire".light()
		Sounds.playPosSound("res://Boom.wav", global_position, 600, 15, 0.0, 0.5, 1)
		queue_free()
