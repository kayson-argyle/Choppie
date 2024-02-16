extends Node2D

class_name Boss

export var healthFrame = 0
export var healthBackFrame = 0
export var health = 200

var alive = true

signal defeated

func activate():
	Global.bossHealth = health
	Global.currentBossHealth = health
	Global.camera.get_node("CanvasLayer/Control/BossHealth").visible = true
	Global.camera.get_node("CanvasLayer/Control/BossHealth/Bar").frame = healthFrame
	Global.camera.get_node("CanvasLayer/Control/BossHealth/Background").frame = healthBackFrame

func defeated():
	emit_signal("defeated")
	pass
	

func ouchie(area):
	Global.currentBossHealth -= area.get_parent().get_damage()
	Global.camera.shake(0.3, 0.8, 0.3, area.get_parent().get_damage())
	area.get_parent().destroy()
	if Global.currentBossHealth <= 0:
		Global.currentBossHealth = 0
		if alive:
			alive = false
			Global.camera.get_node("CanvasLayer/Control/BossHealth").visible = false
			defeated()
