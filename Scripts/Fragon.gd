extends Boss


export var fireballCount = 0

var fireball = preload("res://Fireball.tscn")
var snipeFireball = preload("res://SnipeFireball.tscn")
var tornadoLoad = preload("res://FragonTornado.tscn")
var bigFire = preload("res://BigFireball.tscn")

var random = RandomNumberGenerator.new()
var velocityCalc = 0
var tornadoStartPos = Vector2.ZERO
var tween = Tween.new()
var stateMachine
var attack = false
var pushPlayer = false
var tordano = false
var player
export var strafer = false
var attackStats = [1, 1, 1]
export var startAttack = false
var prevStartAttack = false

func _ready():
	random.randomize()
	add_child(tween)
	stateMachine = $AnimationTree.get("parameters/playback")

func _process(_delta):
	if not startAttack == prevStartAttack and startAttack:
		doAttack()
	prevStartAttack = startAttack
	if pushPlayer and tordano:
		player.motion.x -= 20
	if pushPlayer and strafer:
		player.motion.x -= 20

func shoot():
	fireballCount += 1
	var projectile = fireball.instance()
	$Fireballs.add_child(projectile)
	projectile.global_position = $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Head.global_position
	random.randomize()
	velocityCalc = (player.position.x - projectile.global_position.x) / sqrt(2 * (player.position.y - projectile.global_position.y - 15) / 300)
	projectile.get_child(0).apply_central_impulse(Vector2(velocityCalc + ((fireballCount -1) * 10), 0))
	
	
func shootSnipeFireball():
	call_deferred("ssf")
	
func ssf():
	var snipeInst = snipeFireball.instance()
	$Fireballs.add_child(snipeInst)
	snipeInst.global_position = $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Head.global_position
	snipeInst.look_at(Global.player.global_position + Vector2(0, -7.5))
	snipeInst.rotation_degrees -= 180
	var angle = Global.player.global_position - snipeInst.global_position + Vector2(0, -7.5)
	var velocity = sqrt(pow(angle.y, 2) + pow(angle.x, 2))
	angle.y = angle.y / velocity * 200
	angle.x = angle.x / velocity * 200
	snipeInst.velocity = angle
	Sounds.playPosSound("res://breathFire.wav", $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Head.global_position, 350, 5)

func ouchie(area):
	Global.currentBossHealth -= area.get_parent().get_damage()
	Global.camera.shake(0.3, 0.8, 0.3, area.get_parent().get_damage())
	area.get_parent().destroy()
	if Global.currentBossHealth <= 0:
		Global.currentBossHealth = 0
		if alive:
			stateMachine.travel("Desaturate")
			alive = false
			$StaticBody2D.collision_layer = 0
			$Particles2D.emitting = false
			tordano = false
			strafer = false
			Global.camera.get_node("CanvasLayer/Control/BossHealth")
			
			yield(get_tree().create_timer(3), "timeout")
			Music.mute(true, 3)
			strafer = false
			$Particles2D.emitting = false
			

func _on_Head_area_entered(area):
	if "SeedCollision" in area.get_name():
		ouchie(area)
	if "SeedTrigger" in area.get_name():
		area.get_parent().trigger()

func _on_Jaw_area_entered(area):
	if "SeedCollision" in area.get_name():
		ouchie(area)
	if "SeedTrigger" in area.get_name():
		area.get_parent().trigger()

func tornadoStarter():
	Sounds.playPosSound("res://breathFire.wav", $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Head.global_position, 350, 5)
	var snipeInst = snipeFireball.instance()
	$Fireballs.add_child(snipeInst)
	snipeInst.tornadoStarter = true
	snipeInst.global_position = $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Head.global_position
	
	snipeInst.rotation_degrees -= 45
	snipeInst.velocity = Vector2(-200, 200)

func actualTornado():
	tordano = true
	$Particles2D.emitting = true
	var tornado = tornadoLoad.instance()
	$Fireballs.add_child(tornado)
	tornado.global_position = tornadoStartPos + Vector2(0, 3)
	tween.interpolate_property(tornado.get_node("Trail"), "modulate:a", 0, 1, 2)
	tween.start()
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3.8
	timer.start()
	yield(timer, "timeout")
	tornado.acceleration = -65
	tornado.velocity = -20
	$Particles2D.emitting = false
	timer.wait_time = 1
	timer.start()
	yield(timer, "timeout")
	tordano = false
	timer.wait_time = 2
	timer.start()
	yield(timer, "timeout")
	tornado.emitting = false
	timer.wait_time = 3
	timer.start()
	yield(timer, "timeout")
	tornado.queue_free()

func doAttack():
	Global.currentBossHealth = health
	Global.bossHealth = health
	var r
	if attack:
		var totalProb = 0
		for i in attackStats:
			totalProb += i
		
		if Global.currentBossHealth / Global.bossHealth < 0.66 and $KillFire.emitting == false:
			r = totalProb + 1
		else:
			r = random.randf_range(0, totalProb)
			
		if r <= attackStats[0]:
			stateMachine.travel("SnipeFireball")
			attackStats[0] *= 0.5
			attackStats[1] *= 1.5
			attackStats[2] *= 1.5
		elif r <= attackStats[0] + attackStats[1]:
			stateMachine.travel("Tord")
			attackStats[0] *= 1.5
			attackStats[1] *= 0.5
			attackStats[2] *= 1.5
		elif r <= attackStats[0] + attackStats[1] + attackStats[2]:
			stateMachine.travel("Strafe")
			attackStats[0] *= 1.5
			attackStats[1] *= 1.5
			attackStats[2] *= 0.5
		else:
			stateMachine.travel("BigFireball")
	
	else:
		
		stateMachine.travel("Idle")





func _on_Area2D_area_entered(area):
	if "Item Pick" in area.get_name():
		pushPlayer = true
		player = area.get_parent().get_parent()


func _on_Area2D_area_exited(area):
	if "Item Pick" in area.get_name():
		pushPlayer = false

func flap(db):
	Sounds.playPosSound("res://flap.wav", $polygons/Skeleton2D/Hip/Chest/TopWing.global_position, 800, db + 10)

func strafe():
	var snipeInst = snipeFireball.instance()
	$Fireballs.add_child(snipeInst)
	snipeInst.global_position = $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Head.global_position
	
	var headRot = $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Head.global_rotation
	var jawRot = $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Jaw.global_rotation
	var headVector = Vector2(cos(headRot), sin(headRot))
	var jawVector = Vector2(cos(jawRot), sin(jawRot))
	var vFinal = (headVector + jawVector).normalized()
	snipeInst.velocity = vFinal * 220
	snipeInst.rotation = vFinal.angle() + PI
	
	
	
	Sounds.playPosSound("res://breathFire.wav", $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Head.global_position, 350, 5)
	
	
func deathSound():
	Sounds.playPosSound("res://fragonDeath.ogg", global_position, 500, 15)
	Global.camera.shake(0.3, 0.8, 8, 30)

func bigBoy():
	Sounds.playPosSound("res://breathFire.wav", $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop/Head.global_position, 350, 15, 0.1, 0.8)
	var bf = bigFire.instance()
	$Fireballs.add_child(bf)
	bf.global_position = $polygons/Skeleton2D/Hip/Chest/NeckBottom/NeckTop.global_position + Vector2(0, 5)
