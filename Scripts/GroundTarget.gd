extends Sprite

signal hit
var random = RandomNumberGenerator.new()

func _on_Area2D_area_entered(area):
	if "SeedCollision" in area.get_name():
		emit_signal("hit")
		area.get_parent().destroy()
		hit()
	if "SeedTrigger" in area.get_name():
		emit_signal("hit")
		area.get_parent().trigger()
		hit()

func hit():
	get_node("AudioStreamPlayer" + str(random.randi_range(1, 4))).play()
