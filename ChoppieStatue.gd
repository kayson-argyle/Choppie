extends Boss

var attack = false
var throwTimer = 0
var acorn = preload("res://EnemyAcorn.tscn")
var canActivate = false

func activate():
	.activate()
	$Boss/Move.play("Start")


func attack():
	$Boss/Head/CollisionShape2D.disabled = false
	$Boss/Run.play("Run")
	$Boss/Move.play("Move")
	attack = true


func _process(delta):
	if attack:
		throwTimer += delta
		if throwTimer >= 2.5:
			throw()
			throwTimer = 0

func defeated():
	.defeated()
	attack = false
	$Boss/Run.play("Stand")
	$Boss/Move.play("Drop")

func _on_Area2D_area_entered(area):
	if "Axe Collision" in area.get_name() and canActivate:
		canActivate = false
		activate()

func throw():
	for i in 3:
		var distMod = i-1
		var a = acorn.instance()
		$Boss/ChoppieStatue/SeedHolder.add_child(a)
		a.global_position = $Boss/ChoppieStatue/Position2D2.global_position
		var playerDist = Global.player.global_position.x - $Boss/ChoppieStatue/Position2D2.global_position.x + 15*distMod
		var vy = 165.0
		var grav = 240.0
		var riseTime = vy/grav
		var something = 2* (22.0 + (vy * riseTime)) / grav
		print(sqrt(something))
		#do kinematic equations to figure out how long acorn will be in the air, then divide the estimated distance to get the needed x velocity
		var timey = 1.0833
		
		var vx = playerDist /timey
		a.linear_velocity = Vector2(vx, -vy)
	
	


func _on_Head_area_entered(area):
	if "SeedCollision" in area.get_name():
		ouchie(area)
	if "SeedTrigger" in area.get_name():
		area.get_parent().trigger()
