extends Projectile

var target

func trigger(enemy):
	target = enemy
	collision_layer = 0
	collision_mask = 0
	$Sprite.modulate.a = 0
	$SeedTrigger.collision_layer = 0
	$SeedTrigger.collision_mask = 0
	call_deferred("load_squid")
	yield(get_tree().create_timer(2.5), "timeout")
	queue_free()
	
func load_squid():
	var squid = load("res://AttackSquid.tscn")
	var sqinst = squid.instance()
	target.add_child(sqinst)
	sqinst.call_deferred("ok")
	sqinst.global_position = position
	
