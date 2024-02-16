extends Lever

func _ready():
	if WorldVars.windmillOn:
		pulled = true
		action()

func action():
	.action()
	if $"../Door".gearSounds == null:
		$"../Door".gearSounds = Sounds.playPosSound("res://gears.wav", global_position, 200, 0, 0)
	$"../BigGear".speed = 1
	$"../BigGear2".speed = -1
	$"../SmallGear".speed = -2
	$"../SmallGear2".speed = 2
	$"../BuildingOutside/Blades".speed = 0.5
	WorldVars.windmillOn = true


func inaction():
	.inaction()
	if $"../Door".gearSounds != null:
		$"../Door".gearSounds.playing = false
		$"../Door".gearSounds = null
	$"../BigGear".speed = 0
	$"../BigGear2".speed = 0
	$"../SmallGear".speed = 0
	$"../SmallGear2".speed = 0
	$"../BuildingOutside/Blades".speed = 0
	WorldVars.windmillOn = false
