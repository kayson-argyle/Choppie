extends Projectile

func trigger(_e):
	collision_layer = 0
	collision_mask = 0
	$Sprite.modulate.a = 0
	Sounds.playPosSound("res://Boom.wav", global_position, 300, -10, 0.2, 1.5)
	var poof = load("Explosion.tscn")
	var poofinst = poof.instance()
	add_child(poofinst)
	poofinst.emitting = true
	$SeedTrigger.collision_layer = 0
	$SeedTrigger.collision_mask = 0
	$ApophysisHolder/Control.visible = true
	call_deferred("load_apop")
	yield(get_tree().create_timer(2.5), "timeout")
	queue_free()

func load_apop():
	var rot = 0
	var apop = load("res://Apophysis.tscn")
	for _i in range(8):
		var apopinst = apop.instance()
		$ApophysisHolder.add_child(apopinst)
		apopinst.global_position = position
		apopinst.force(cos(rot) * 300, sin(rot) * 300)
		apopinst.rotation = rot / PI * 180 - 135 
		rot += 0.25 * PI


