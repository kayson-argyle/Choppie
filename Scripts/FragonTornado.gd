extends Particles2D

var playerInside = false
var velocity = 0
var acceleration = 0
var random = RandomNumberGenerator.new()

func _ready():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($Area2D, "scale", Vector2.ZERO, Vector2.ONE, 3, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property($Light2D, "scale", Vector2.ZERO, Vector2(0.388, 0.377), 3, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	


func _process(delta):
	if playerInside:
		Global.player.motion.y -= 720 * delta
		Global.player.motion.x += (global_position.x - Global.player.global_position.x) * 100 * delta
	position.x += velocity * delta
	velocity += acceleration * delta
	$Whoosh.global_position = Global.camera.global_position + global_position - Global.player.global_position


func _on_Area2D_area_entered(area):
	
	if area.get_parent().has_method("apply_central_impulse"):
		random.randomize()
		area.get_parent().apply_central_impulse(Vector2(random.randf_range(-270, 80), -270))





func _on_Area2D_body_entered(body):
	if "Player" in body.get_name():
		playerInside = true
		Global.player.damage(400)
		Global.camera.shake(0.3, 0.8, 1.2, 55)


func _on_Area2D_body_exited(body):
	if "Player" in body.get_name():
		playerInside = false
