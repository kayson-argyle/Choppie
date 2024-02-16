extends Particles2D

var timer = 0
var tween = Tween.new()

func _ready():
	add_child(tween)
	tween.name = "Tween"

func _process(delta):
	if emitting:
		timer += delta
		if timer > 20:
			emitting = false
			timer = 0
			$Area2D.collision_layer = 0
			$Area2D.collision_mask = 0
			tween.interpolate_property($ShapeableLight.get_material(), "shader_param/brightness", $ShapeableLight.get_material().get_shader_param("brightness"), 0, 2.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
func light():
	tween.stop_all()
	$"Area2D".collision_layer = 6
	$"Area2D".collision_mask = 6
	if emitting == false:
		tween.interpolate_property($ShapeableLight.get_material(), "shader_param/brightness", $ShapeableLight.get_material().get_shader_param("brightness"), 5, 2.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	emitting = true
