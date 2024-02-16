extends StaticBody2D

class_name TreeBoi

export var seedName = "Acorn"
var touchingAxe = false;
var totalHits = 0
var acornOut = false
export var seedLimit = 9
export var hitsForSeed = 10
var acornAmount = 5
var loadedSeed
var seedData = {}
var seedTexture

onready var sprite = $Sprite

func _ready():
	Global.register("tree", self)
	loadedSeed = load("res://Seed.tscn")
	seedData = Global.seedData


func _physics_process(_delta):
	if touchingAxe:
		if Global.isChopping and Global.canGetWood:
			Global.canGetWood = false
			action()
			Sounds.playPosSound("res://treeHit.wav", global_position, 100, 0, 0.05)
			Global.player.axe_hit()
			totalHits += 1
			if totalHits % hitsForSeed == 0 && $SeedHolder.get_child_count() < seedLimit:
				
				var seedInstance = loadedSeed.instance()
				$SeedHolder.add_child(seedInstance)
				seedTexture = load(seedData[seedName]["Texture"])
				seedInstance.get_child(0).frame = Global.seedNames.find(seedName)
				seedInstance.type = seedName
				seedInstance.fromTree = true
				if Global.player.global_position.x > global_position.x:
					seedInstance.global_position = $Position2D.global_position
					seedInstance.apply_impulse(Vector2(), Vector2(rand_range(-20, -50), rand_range(-10, -30)))
				else:
					seedInstance.global_position = $Position2D2.global_position
					seedInstance.apply_impulse(Vector2(), Vector2(rand_range(20, 50), rand_range(-10, -30)))
						
	
	

func _on_Area2D_area_entered(area):
	if "Axe Collision" in area.get_name():
		touchingAxe = true
	if "Beetle Hit" in area.get_name():
		var _yee = get_tree().change_scene("res://GameOver.tscn")
		


func _on_Area2D_area_exited(area):
	if "Axe Collision" in area.get_name():
		touchingAxe = false


func action():
	pass
