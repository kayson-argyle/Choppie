tool
extends AnimatedSprite

var dragging = false
var areaNode
export var amount = 0
var mouse = false
var mouseTimer = 0
var dead = false
onready var startPos = position

onready var tween = $Tween


func _process(delta):
	$Amount.text = str(amount)
	if amount <= 0 :
		$Amount.visible = false
	else:
		$Amount.visible = true
	if dragging:
		global_position = get_global_mouse_position()
		mouseTimer = 0
	if mouse:
		mouseTimer += delta
		if mouseTimer > 1:
			$Label.visible = true
			$Label.global_position = get_global_mouse_position() + Vector2(-1.5, -1.5)
			$Label/Label.text = "Type: " + Global.seedData.keys()[frame] + "\nAmount: " + str(amount)
		else:
			$Label.visible = false

func _on_TextureButton_button_down():
	print("space")
	if mouse:
		select()

func _on_TextureButton_button_up():
	$TextureButton.release_focus()
	print("spacebar")
	if areaNode != null:
		var selectedPoint = areaNode.get_parent()
		var spAmount = selectedPoint.amount
		var spFrame = selectedPoint.frame
		var oldAmount = amount
		var oldFrame = frame
		selectedPoint.amount = oldAmount
		selectedPoint.frame = oldFrame
		frame = spFrame
		amount = spAmount
		tween.stop_all()
		tween.interpolate_property(selectedPoint, "scale", scale, Vector2(1, 1), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		tween.start()
		scale = Vector2(1, 1)
	position = startPos
	dragging = false
	z_index = 1
	mouse = false
	mouseTimer = 0
	$Label.visible = false
	areaNode = null

	
func _on_SnapArea_area_entered(area):
	areaNode = area
	
	
func select():
	tween.stop_all()
	tween.interpolate_property(self, "scale", scale, Vector2(0.6, 0.6), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	z_index = 2
	dragging = true


func _on_TextureButton_mouse_entered():
	mouse = true


func _on_TextureButton_mouse_exited():
	mouse = false
	mouseTimer = 0
	$Label.visible = false
	
func changeAmount(integer):
	if not dead:
		amount += integer
		if amount <= 0:
	
			frame = 0
			var pop = load("res://DarkWoodDust.tscn")
			var popinst = pop.instance()
			add_child(popinst)
			popinst.global_position = global_position
			popinst.scale *= 2
			popinst.emitting = true
			yield(get_tree().create_timer(2.0), "timeout")
			popinst.queue_free()

func tooMany():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("TooMany")
