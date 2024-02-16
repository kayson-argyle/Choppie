extends RigidBody2D

class_name Enemy

onready var health = $ProgressBar.max_value
export var deathSound = ""
export var droppedItem = ""
export var dropRate = 0.5
var canDamage = true
var random = RandomNumberGenerator.new()
signal damage(value)
signal death
var doFlash = true
var doShake = true


func _ready():
	random.randomize()

func damage(d):
	if canDamage:
		hit()
		health -= d
		emit_signal("damage", health)
		$ProgressBar.value = health
		health = clamp(health, 0, $ProgressBar.max_value)
		if doFlash and d > 1:
			$Flash.play("Flash")
		if doShake:
			Global.camera.shake(0.5, 0.8, 0.2, 0.2)
		if health <= 0:
			emit_signal("death")
			canDamage = false
			if deathSound != "":
				Sounds.playSound(deathSound)
			call_deferred("death")

func _on_Hitbox_area_entered(area):
	if "SeedCollision" in area.get_name():
		damage(area.get_parent().get_damage())
		area.get_parent().destroy()
	if "SeedTrigger" in area.get_name():
		area.get_parent().trigger(self)
		
func death():
	if droppedItem != "":
		var item = load("res://Seed.tscn")
		if random.randf_range(0, 1) < dropRate:
			var iInst = item.instance()
			get_parent().add_child(iInst)
			iInst.global_position = global_position
			
			iInst.setType(droppedItem)
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "scale", scale, Vector2(0, 0), 0.2, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()

func hit():
	pass
