tool
extends Area2D

export var zoom = Vector2(2, 2)
export var boxSize = Vector2(10, 10)
export var yOffset = 0.0
export var setPosition = false
export var goToPosition = Vector2(0, 0)
export var startBoss = false
onready var boss = get_parent()
onready var bossHealth = Global.camera.get_node("CanvasLayer/Control/BossHealth")
var preZoom = Vector2(1, 1)
var revert = false
var getEasing = 1
var startPos = Vector2(0, 0)

func _ready():
	$CollisionShape2D.shape.extents = boxSize
	
func _process(_delta):
	if Engine.editor_hint:
		$CollisionShape2D.shape.extents = boxSize
		var v = get_viewport_rect().size
		$Line2D.points = [Vector2(v.x/2 * zoom.x, v.y/2 * zoom.y), Vector2(-v.x/2 * zoom.x, v.y/2 * zoom.y), Vector2(-v.x/2 * zoom.x, -v.y/2 * zoom.y), Vector2(v.x/2 * zoom.x, -v.y/2 * zoom.y), Vector2(v.x/2 * zoom.x, v.y/2 * zoom.y)]
	else:
		$Line2D.points = []
	
func _physics_process(_delta):
	if revert:
		
		if getEasing == 1:
			revert = false
			Global.camera.lockPos = false
			return
		Global.camera.nextPos = startPos.linear_interpolate(Global.camera.unlockedPos, getEasing)

	getEasing = 0
		
func _on_CameraTrigger_area_entered(area):
	if "Item Pick" in area.get_name():
		Music.playMusic("res://fragonFight.ogg")
		#Music.mute(true)
		Sounds.shiftSound = true
		
		AudioServer.set_bus_effect_enabled(1, 0, true)
		AudioServer.set_bus_effect_enabled(1, 1, true)
		
		$Tween.stop_all()
		preZoom = Global.camera.zoom
		$Tween.interpolate_property(Global.camera, "zoom", Global.camera.zoom, zoom, 2, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		if setPosition:
			Global.camera.lockPos = true
			$Tween.interpolate_property(Global.camera, "nextPos", Global.camera.position, goToPosition + global_position, 2, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		$Tween.start()
		if startBoss and boss.alive:
			boss.attack = true
			boss.doAttack()
			bossHealth.visible = true


func _on_CameraTrigger_area_exited(area):
	call_deferred("exit", area)
	
func exit(area):
	if is_instance_valid(area):
		if "Item Pick" in area.get_name():
			Sounds.shiftSound = false
			
			AudioServer.set_bus_effect_enabled(1, 0, false)
			AudioServer.set_bus_effect_enabled(1, 1, false)
			
			
			$Tween.stop_all()
			$Tween.interpolate_property(Global.camera, "zoom", Global.camera.zoom, Vector2(1, 1), 2, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			if setPosition:
				revert = true
				startPos = Global.camera.nextPos
			$Tween.interpolate_property(self, "getEasing", 0, 1, 2, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			
			$Tween.start()
			if startBoss:
				boss.attack = false
				bossHealth.visible = false
