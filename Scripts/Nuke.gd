
extends Projectile

var wiggleTimer = 0
var wiggleDist = 0
var detonated = false

onready var explosion = preload("res://Explosion.tscn")

func _process(delta):
	wiggleTimer += delta
	wiggleDist = sin(wiggleTimer * 16.5)
	for i in get_children():
		if "position" in i:
			i.position = Vector2(wiggleDist * cos($Sprite.rotation), wiggleDist * sin($Sprite.rotation))
		if "rotation" in i:
			i.rotation = linear_velocity.angle() + PI / 2
	
	
func onThrow():
	gravity_scale = 0
	
	
func trigger(e):
	Sounds.playPosSound("res://Boom.wav", global_position, 350, 10)
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
	einst.scale = Vector2(7, 7) #Vector2(7/51*$SeedCollision/SeedShape.get_shape().radius, 7/51*$SeedCollision/SeedShape.get_shape().radius)
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
