extends CanvasLayer


var a = preload("res://Enemies/Bosses/Fragon/SnipeFireballParticleLoader.tres")
var b = preload("res://Tornado.tres")
var c = preload("res://TornadoDirt.tres")
var d = preload("res://TornadoStarter.tres")
var e = preload("res://TornadoTrail.tres")

var materials = [
	a,
	b,
	c,
	d,
	e
]

func _ready():
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		particles_instance.visible = false
		self.add_child(particles_instance)
