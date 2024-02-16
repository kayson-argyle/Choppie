extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var touchingAxe = false;
var oakWood = 0
var acornOut = false
var acorn = preload("res://Acorn.tscn")
var activeAcornCount = 0
var acornAmount = 5


onready var oakSprite = $"sizeable oak"
onready var player = get_node("/root/World/Player")

# Called when the node enters the scene tree for the first time.


func _physics_process(_delta):
	if touchingAxe:
		if Input.is_action_just_pressed("ui_select"):
			oakWood +=1
			$AxeHit.play()
			player.axe_hit()
			if oakWood % 10 == 0 && activeAcornCount < 9:
				
				var acornInstance = acorn.instance()
				add_child(acornInstance)
				activeAcornCount += 1
				acornInstance.pickUp = true
				if player.position.x > position.x:
					acornInstance.position = $Position2D.position
					acornInstance.apply_impulse(Vector2(), Vector2(rand_range(-20, -50), rand_range(-10, -30)))
				else:
					acornInstance.position = $Position2D2.position
					acornInstance.apply_impulse(Vector2(), Vector2(rand_range(20, 50), rand_range(-10, -30)))
						
	
	

func _on_Area2D_area_entered(area):
	if "Axe Collision" in area.get_name():
		touchingAxe = true
	if "Beetle Hit" in area.get_name():
		var _yee = get_tree().change_scene("res://GameOver.tscn")
		


func _on_Area2D_area_exited(area):
	if "Axe Collision" in area.get_name():
		touchingAxe = false
