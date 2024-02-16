extends Projectile

func _ready():
	gravity_scale = -0.5
	linear_velocity = Vector2(0,0)
	var timery = Timer.new()
	add_child(timery)
	timery.wait_time = 0.5
	timery.start()
	call_deferred("onThrow")
	yield(timery, "timeout")
	collision_layer = 6
	collision_mask = 6
