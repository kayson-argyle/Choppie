extends Level

var tween = Tween.new()
var textNum = 0
var inventoryOpen = false
var fallLoop = false
var timer = 0
var advanceTimer = false
var targets1down = 0
var targets2down = 0
var targets3down = 0
var wind = false
var seedsOut = false
var byDoor = false

signal timeout

func _ready():
		
	add_child(tween)
	var file = File.new()
	file.open("res://Data/Dialogue.json", File.READ)
	var text = file.get_as_text()
	file.close()
	Global.dialogue.open(parse_json(text)["Tutorial"], true)
	if byDoor:
		Global.dialogue.setNum(7)


func _process(delta):
	var pointer = $Player/CameraHolder/Camera2D/CanvasLayer/Control/Inventory/Pointer/Pointer
	if advanceTimer:
		timer += delta
		if timer > 2:
			emit_signal("timeout")
	if Input.is_action_just_pressed("inventory"):
		inventoryOpen = not inventoryOpen
		if inventoryOpen and fallLoop:
			Global.dialogue.setNum(6)
			pointer.get_parent().visible = true
			pointer.play("Drag")
		
	if not (inventoryOpen and fallLoop):
		pointer.stop()
		pointer.get_parent().visible = false
		
	if fallLoop and $Player.global_position.y > $FallPos.position.y:
		$Player.motion = Vector2.ZERO
		$Player.gravity = 0
		$Player/CameraHolder/Camera2D/CanvasLayer/Control/Wind.emitting = true
		$Player/CameraHolder/Camera2D/Fall.playback_speed = 1
		if $Player/CameraHolder/Camera2D/CanvasLayer/Control/Inventory/Slots/InventoryPoint3.has_node("Item"):
			fallLoop = false
			$Player.global_position = $Pos2.position
			$Player/CameraHolder/Camera2D/Fall.stop()
			tween.interpolate_property($Player/CameraHolder/Camera2D, "rotation_degrees", $Player/CameraHolder/Camera2D.rotation_degrees, 0, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.interpolate_property($Player/CameraHolder/Camera2D, "shakeOffset", $Player/CameraHolder/Camera2D.shakeOffset, Vector2(0, 0), 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)			
			tween.start()
	else:
		$Player/CameraHolder/Camera2D/CanvasLayer/Control/Wind.emitting = false
		$Player.gravity = Global.gravity
		$Player/CameraHolder/Camera2D/Fall.playback_speed = 0
	
	if wind:
		Global.player.motion += Vector2(-100, -300) * delta

func _on_W_body_entered(body):
	if "Player" in body.get_name():
		Global.dialogue.setNum(3)

func _on_WW_body_entered(body):
	if "Player" in body.get_name():
		Global.dialogue.setNum(4)

func _on_I_body_entered(body):
	if "Player" in body.get_name():
		Global.dialogue.setNum(5)
		fallLoop = true

func _on_QE_body_entered(body):
	if "Player" in body.get_name():
		tween.interpolate_property($Player/CameraHolder/Camera2D, "zoom", $Player/CameraHolder/Camera2D.zoom, Vector2(2, 2), 2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		tween.start()
		
func _on_QE_body_exited(body):
	if "Player" in body.get_name():
		tween.interpolate_property($Player/CameraHolder/Camera2D, "zoom", $Player/CameraHolder/Camera2D.zoom, Vector2(1, 1), 2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		tween.start()

func _on_Sizeable_Oak_seedsFull():
	seedsOut = true
	Global.dialogue.setNum(1)

func _on_S_body_entered(body):
	if "Player" in body.get_name():
		Global.dialogue.setNum(7)


func _on_Start_Particles_body_entered(body):
	if "Player" in body.get_name():
		Global.dialogue.close()
		tween.interpolate_property($Smoke, "scale", Vector2.ZERO, Vector2(0.2, 0.2), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property($Smoke, "modulate:a", 0, 1, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
		$Smoke/MovingSmoke.emitting = true

func targets1():
	targets1down += 1
	if targets1down == 3:
		$FlyingTarget4.show()
		$Node2D/FlyingTarget5.show()

func _on_FlyingTarget1_death():
	targets1()


func _on_FlyingTarget2_death():
	targets1()


func _on_FlyingTarget3_death():
	targets1()


func _on_TurnOffDia_body_entered(body):
	if "Player" in body.get_name():
		Global.dialogue.close()
		respawnPos = $FallPos.global_position


func _on_DontFall_body_entered(body):
	if "Player" in body.get_name():
		Global.player.global_position = $Pos2.global_position


func _on_FlyingTarget4_death():
	targets2()


func _on_FlyingTarget5_death():
	targets2()

func targets2():
	targets2down += 1
	if targets2down == 2:
		$Node2D2/FlyingTarget6.show()
		$Node2D3/FlyingTarget7.show()


func _on_FlyingTarget6_death():
	targets3()

func targets3():
	targets3down += 1
	if targets3down == 2:
		Sounds.playSound("res://Gong-sound.ogg")
		$ChoppieStatue.canActivate = true

func finished():
	Sounds.playSound("res://Gong-sound.ogg")
	yield(get_tree().create_timer(0.5), "timeout")
	$Wind.amount = 100
	Sounds.playSound("res://WindGust.wav")
	yield(get_tree().create_timer(0.5), "timeout")
	wind = true
	Global.player.drag = 0
	Global.player.controlMov = false
	


func _on_FlyingTarget7_death():
	targets3()


func _on_SmokeyBoi_body_entered(body):
	if "Player" in body.get_name():
		Global.player.drag = 2
		Global.player.vertDrag = 2
		yield(get_tree().create_timer(10), "timeout")
		Global.doorDir = "in"
		Global.changeScene("res://ChoppiesVillage.tscn")


func _on_Chop_body_entered(body):
	if seedsOut:
		Global.dialogue.setNum(1)


func _on_ChoppieStatue_defeated():
	finished()
