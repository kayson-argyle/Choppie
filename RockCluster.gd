extends Destructable

func _ready():
	if WorldVars.waterfallRockDestroyed:
		call_deferred("destroy")

func destroy():
	.destroy()
	WorldVars.waterfallRockDestroyed = true
