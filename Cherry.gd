extends Projectile

var detonated = false

onready var explosion = preload("res://Explosion.tscn")

func trigger(_e):
	Sounds.playPosSound("res://Boom.wav", global_position, 300, -10, 0.2, 1.5)
	$SeedCollision.collision_layer = 6
	var seedCollision = $SeedCollision
	remove_child(seedCollision)
	var n = load("res://DamageHolder.tscn")
	var node = n.instance()
	node.damage = get_damage()
	node.speedCalc1 = speedCalc1
	node.speedCalc2 = speedCalc2
	node.Delta = Delta
	get_parent().add_child(node)
	node.add_child(seedCollision)
	seedCollision.global_position = global_position
	seedCollision.kill()
	linear_velocity = Vector2.ZERO
	var einst = explosion.instance()
	get_parent().add_child(einst)
	einst.scale = Vector2(3, 3) #Vector2(7/51*$SeedCollision/SeedShape.get_shape().radius, 7/51*$SeedCollision/SeedShape.get_shape().radius)
	einst.global_position = global_position
	call_deferred("queue_free")
	



func _on_Detonator2_area_entered(area):
	if not "SeedCollision" in area.get_name() and not "Item Pick" in area.get_name() and not detonated:
		call_deferred("trigger", 0)
		detonated = true


func _on_Detonator_body_entered(body):
	if not "Player" in body.get_name() and not detonated:
		call_deferred("trigger", 0)
		detonated = true
