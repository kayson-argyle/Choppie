extends Interactable

var open = false

func _ready():
	TeleportDoors.register(get_parent(), get_parent().tag, global_position)
	if get_parent().activated:
		get_parent().visible = true
	else:
		get_parent().visible = false

func interact():
	if not open and get_parent().activated:
		open = true
		$Outline.visible = false
		$"../AnimationPlayer".play("Open")
		Global.player.controlMov = false
		yield($"../AnimationPlayer", "animation_finished")
		TeleportDoors.teleport(get_parent().toDoorTag, get_parent(), Global.player.global_position - get_parent().global_position)
		
