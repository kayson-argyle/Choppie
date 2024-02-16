extends Node2D

signal opened
var tween = Tween.new()

func _ready():
	add_child(tween)

var shown = false
func show():
	if shown == false:
		shown = true
		visible = true
		$Label.modulate.a = 0
		$Label/Button.modulate.a = 0
		tween.interpolate_property(self, "modulate:a", 0, 1, 3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		emit_signal("opened")
		tween.interpolate_property($Label, "modulate:a", 0, 1, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		$Label/Button.visible = true
		tween.interpolate_property($Label/Button, "modulate:a", 0, 1, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()



func _on_Button_pressed():
	if get_tree().get_current_scene().respawnPos == null:
		Global.changeScene(Global.respawnScene)
	else:
		Global.changeScene(Global.respawnScene, 1, true, get_tree().get_current_scene().respawnPos)
	shown = false
	get_tree().paused = false
	visible = false
	Global.player.alive = true
	Global.choppieHealth = 1000.0
	Global.player.damage(0)
	Global.currentBossHealth = 1000.0
	Global.player.position = Global.player.startPos
	Global.inventory.resetInventory()
	Global.survivalTime = 0
