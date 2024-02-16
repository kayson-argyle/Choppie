extends RigidBody2D

class_name Projectile

var speedCalc1 = Vector2.ZERO
var speedCalc2 = Vector2.ZERO
var Delta = 0
var kill = 0
var timer = 0
export var doTimer = true
var angle = 0

var tween = Tween.new()

var damage = 10 setget set_damage, get_damage
func set_damage(d):
	damage = d
func get_damage():
	return damage


var dust

func _ready():
	linear_velocity = Vector2(0,0)
	if gravity_scale != 0:
		gravity_scale = Global.gravityScale
	dust = load("res://WoodDust.tscn")
	var timery = Timer.new()
	add_child(timery)
	timery.wait_time = 0.5
	timery.start()
	call_deferred("onThrow")
	yield(timery, "timeout")
	collision_layer = 6
	collision_mask = 6
	
	

func _process(delta):
	speedCalc1 = speedCalc2
	speedCalc2 = position
	Delta = delta
	timer += delta
	if timer > 5 and kill == 0:
		add_child(tween)
		kill = 1
		tween.interpolate_property(self, "scale", scale, Vector2(0, 0), 0.25, Tween.TRANS_BACK, Tween.EASE_IN)
		tween.start()
	if kill == 1 and !tween.is_active():
		collision_mask = 0
		collision_layer = 0
		get_child(0).visible = false
		
		var dustybob = dust.instance()
		add_child(dustybob)
		dustybob.emitting = true
		set_process(false)
		kill = 2
		yield(get_tree().create_timer(1), "timeout")
		queue_free()

func trigger(_enemy):
	pass
	
func playHitSound():
	pass

func destroy():
	$SeedCollision.collision_mask = 0
	$SeedCollision.collision_layer = 0
	collision_mask = 0
	collision_layer = 0
	get_child(0).visible = false
	kill = 2
	var yeeyeedust = dust.instance()
	add_child(yeeyeedust)
	yeeyeedust.emitting = true
	playHitSound()
	var timeyboi = Timer.new()
	add_child(timeyboi)
	timeyboi.wait_time = 1  
	timeyboi.start()
	
	yield(timeyboi, "timeout")
	set_process(false)
	queue_free()
	
func onThrow():
	pass
