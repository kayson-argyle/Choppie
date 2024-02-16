extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 27
var gravity = Global.gravity
const JUMP_FORCE = 128 
var drag = 9
var vertDrag = 0

var motion = Vector2.ZERO
var timer = 0
var dust = preload("res://WoodDust.tscn")
var hit = false
var treeDist = 0
var getHit = 0
var doubleHit = false
var jumpTimer = 0
var isJumpStretching = false
var alive = true
var openSeeds = [null, null, null, null]
var selectedSeed = openSeeds[0]
var hasSeeds = true
var random = RandomNumberGenerator.new()
var interactTarget
var chopTarget
var controlMov = true
var canJump = false
var ground = []
var x_input = 0
var startPos
var setPos = false
var setPosLoc = Vector2()
var checkDrag = false
var chopSpeed = 0.3
var axeTimer = chopSpeed
var spawnPoint

onready var sprite = $Sprite 
onready var axe = $Sprite/Axe
onready var anim = $AnimationPlayer
onready var inventory = $CameraHolder/Camera2D/CanvasLayer/Control/Inventory


signal onGround(boolean)

var ragdoll = preload("res://Ragdoll.tscn")
var jumpParticles = preload("res://JumpParticle.tscn")

var seedJson = {}
var seedAsText = ""

func _ready():
	if Global.playerSetPos:
		global_position = Global.playerSetPosLoc
	startPos = global_position
	loadSeeds()
	Global.register("player", self)
	Global.register("camera", $CameraHolder/Camera2D)
	Global.register("dialogue", $CameraHolder/Camera2D/CanvasLayer/Control/Dialogue)
	seedJson = Global.seedData
	random.randomize()
	damage(0)

func _physics_process(delta):
	if alive:
		x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	else:
		x_input = 0
	if x_input != 0 and controlMov:
		if canJump:
			anim.play("Run")
		if x_input == -1:
			if sprite.scale.x == -1:
				for i in $Things.get_children():
					i.rotation_degrees += 180
			sprite.scale.x = 1
			$Things.scale.x = 1
			if motion.x > -MAX_SPEED:
				motion.x += x_input * ACCELERATION * delta
		else:
			if sprite.scale.x == 1:
				for i in $Things.get_children():
					i.rotation_degrees += 180
			sprite.scale.x = -1
			$Things.scale.x = -1
			if motion.x < MAX_SPEED:
				motion.x += x_input * ACCELERATION * delta
	
	if canJump:
		jumpTimer = 0
	else:
		if jumpTimer >= 0:
			jumpTimer += delta
		else:
			jumpTimer -= delta
	
	if jumpTimer < 0.2 and jumpTimer >= 0 and controlMov and alive:
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
			jumpStretch(1.15, 0.87, 0.1)
			isJumpStretching = true
			Sounds.playPosSound("res://jumpWhoosh.wav", global_position, 100, -20, 0.4, 1)
			jumpTimer = 0.2
	elif alive and controlMov and jumpTimer >= 0:
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE * 1.2
			Sounds.playPosSound("res://jumpWhoosh.wav", global_position, 100, -7, 0.4, 1.2)
			var puff = jumpParticles.instance()
			add_child(puff)
			puff.position = $Sprite.position
			puff.get_child(0).emitting = true
			jumpStretch(1.15, 0.87, 0.1)
			isJumpStretching = true
			jumpTimer = -1
	
	if canJump:
		if x_input == 0:
			timer += delta
			motion.x = lerp(motion.x, 0, FRICTION * delta)
			if timer > 4:
				anim.play("Idle")
			else:
				anim.play("Stand")
		else:
			timer = 0
			motion.x = lerp(motion.x, 0, FRICTION * delta/8)
			
	else: 
		motion.y += gravity * delta
		if x_input == 0:
			motion.x = lerp(motion.x, 0, drag * delta)
			motion.y = lerp(motion.y, 0, vertDrag * delta)
			anim.play("Stand")
			
			
	axeTimer -= delta
	if Input.get_action_strength("ui_select") == 1:
		if axeTimer <= 0:
				axeTimer = chopSpeed
		timer = 0
		if axeTimer > chopSpeed / 2 :
			axe.rotation_degrees = -45
			Global.isChopping = true
		else:
			Global.canGetWood = true
			axe.rotation_degrees = 0
			Global.isChopping = false
			
	else:
			axe.rotation_degrees = 0
			Global.isChopping = false
		
	
	motion = move_and_slide(motion, Vector2.UP)

	
	if Input.is_action_just_pressed("ui_down"):
		Interact.interact()
	
	if checkDrag and canJump:
		checkDrag = false
		drag = 9
	
func axe_hit():
	var woodDust = dust.instance()
	add_child(woodDust)
	var axeOffset = Vector2(-9, -2)
	if sprite.scale.x == -1:
		axeOffset.x *= -1
	woodDust.position = $Sprite.position + axeOffset
	woodDust.emitting = true
	hit = true
	if getHit !=0:
		doubleHit = true

func damage(d):
	Global.choppieHealth -= d
	$Sprite/FlashWhite.play("Flash")
	$CameraHolder/Camera2D/CanvasLayer/Control/Health/HealthBar.scale.x = Global.choppieHealth / 1000
	if Global.choppieHealth <= 0 and alive:
		call_deferred("ragdolly")
		
func heal(h):
	Global.choppieHealth += h
	Global.choppieHealth = clamp(Global.choppieHealth, 0.0, 1000.0)
	$CameraHolder/Camera2D/CanvasLayer/Control/Health/HealthBar.scale.x = Global.choppieHealth / 1000


func ragdolly():
	alive = false
	var death = ragdoll.instance()
	get_parent().add_child(death)
	death.global_position = global_position
	death.position.y += -7
	$Sprite.visible = false
	var deathCam = death.get_node("Camera/Camera2D")
	$CameraHolder/Camera2D.current = false
	deathCam.current = true
	$Tween.interpolate_property($CameraHolder/Camera2D/CanvasLayer/Control, "modulate:a", 1, 0, 0.3, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	$Tween.start()
	death.apply_impulse(Vector2(0, 0), motion)
	random.randomize()
	death.angular_velocity = motion.length() * sign(motion.x) / 15





func _on_Tween_tween_completed(_object, _key):
	if isJumpStretching:
		isJumpStretching = false
		jumpStretch(1, 1, 0.1)
		
func jumpStretch(x, y, t):
	$Tween.stop($Sprite)
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(sign($Sprite.scale.x) * x, y), t, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			throw()

signal thrown

func throw():
	var selectedPoint = inventory.get_node("Slots").get_child(inventory.get_node("Selector").pos)
	if selectedPoint.frame != 0 and selectedPoint.amount != 0:
		var hooplah = seedJson[Global.seedNames[selectedPoint.frame]]
		if hooplah["File"] != null:
			
			var inventorySpot = inventory.getSelection()
			inventorySpot.changeAmount(-1)
			if hooplah["ItemType"] == "Throw":
				var selectedItem = load(str(hooplah["File"]))
				var p = selectedItem.instance()
				$ProjectileHolder.add_child(p)
				p.set_damage(hooplah["Damage"])
				p.position = position
				p.position += Vector2(3 * $Sprite.scale.x, -7.5)
				Sounds.playPosSound("res://whoosh.wav", global_position)
			
				var angle = get_global_mouse_position() - p.global_position
				var velocity = sqrt(pow(angle.y, 2) + pow(angle.x, 2))
				angle.y = angle.y / velocity * hooplah["Speed"]
				angle.x = angle.x / velocity * hooplah["Speed"]
				
				p.apply_impulse(Vector2(), Vector2(angle))
				p.angle = angle.angle()
				emit_signal("thrown")
			elif hooplah["ItemType"] == "Eat":
				var selectedItem = load(str(hooplah["File"]))
				var p = selectedItem.instance()
				add_child(p)
				
func loadSeeds():
	var i = 0
	for item in Global.playerItems:
		var slot = $CameraHolder/Camera2D/CanvasLayer/Control/Inventory/Slots.get_child(i)
		if slot.amount == 0:
			slot.frame = item[0]
			slot.amount = item[1]
		i += 1


func saveSeeds():
	var j = 0
	for slot in $CameraHolder/Camera2D/CanvasLayer/Control/Inventory/Slots.get_children():
		Global.playerItems[j] = [slot.frame, slot.amount]
		j += 1

func _on_Jump_body_entered(body):
	if body.name != "Player":
		Sounds.playPosSound("res://groundhit.wav", global_position, 100, -10, 0.4, 1)
		if not body in ground:
			canJump = true
			ground.append(body)
			emit_signal("onGround", true)


func _on_Jump_body_exited(body):
	if body in ground:
		ground.erase(body)
	if ground == []:
		canJump = false
		emit_signal("onGround", false)
		
func footstep():
	if canJump:
		Sounds.playPosSound("res://steps.wav", global_position, 100, 10, 0.2, 0.6)

func launch(force, var dragTime = 1):
	canJump = false
	jumpTimer = 0.2
	motion = force
	drag = 0
	var timerl = Timer.new()
	add_child(timerl)
	timerl.wait_time = dragTime
	timerl.start()
	yield(timerl, "timeout")
	drag = 9

func resetDrag(time):
	yield(get_tree().create_timer(time), "timeout")
	checkDrag = true
	
