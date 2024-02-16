extends Door

var gearSounds = null

func interact():
	.interact()
	if inside:
		if gearSounds != null:
			gearSounds.volume_db = 0
		$"../Lever".canInteract = true
		$"../BuildingOutside/Blades/StaticBody2D".collision_layer = 0
		$"../BuildingOutside/Blades/StaticBody2D".collision_mask = 0
	else:
		if gearSounds != null:
			gearSounds.volume_db = -10
		$"../Lever".canInteract = false
		$"../BuildingOutside/Blades/StaticBody2D".collision_layer = 7
		$"../BuildingOutside/Blades/StaticBody2D".collision_mask = 7

