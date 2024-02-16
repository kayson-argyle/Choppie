extends Node2D

class_name Destructable

export var health = 50
export var shakeTime = 0.2
export var shakeIntensity = Vector2(3, 3)
export var shakePeriod = 0.1
export var shakePersistence = 0.5
#Global.camera.shake(0.3, 0.8, 0.6, 30) period, persistence, time, power
var doShake = false
var Delta = 0
var noise = OpenSimplexNoise.new()
var random = RandomNumberGenerator.new()
signal destroyed



func _ready():
	noise.octaves = 4
	noise.period = shakePeriod
	noise.persistence = shakePersistence

func _on_Area2D_area_entered(area):
	if "SeedCollision" in area.get_name():
		damage(area.get_parent().get_damage())
		area.get_parent().destroy()
	if "SeedTrigger" in area.get_name():
		area.get_parent().trigger(self)

func _process(delta):
	if doShake:
		Delta += delta
		$Node2D.position.x = noise.get_noise_2d(Delta, 0) * shakeIntensity.x * ((shakeTime - Delta) / shakeTime)
		$Node2D.position.y = noise.get_noise_2d(0, Delta) * shakeIntensity.y * ((shakeTime - Delta) / shakeTime)
		if Delta > shakeTime:
			doShake = false
			Delta = 0
			$Node2D.position = Vector2(0, 0)

func damage(d):
	health -= d
	doShake = true
	if health <= 0:
		destroy()

func destroy():
	emit_signal("destroyed")
	visible = false
	$Node2D/Area2D.collision_mask = 0
	$Node2D/RigidBody2D.collision_layer = 0
