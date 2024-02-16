extends Node

var doors = []

func register(node, name, position):
	doors.append([node, name, position])
	
	
func reset():
	doors = []


func teleport(toDoor, fromDoor, playerOffset):
	for d1 in doors:
		if d1[1] == toDoor:
			d1[0].visible = true
			d1[0].activated = true
			fromDoor.get_node("AnimationPlayer").play("Close")
			fromDoor.get_node("Interactable").open = false
			Global.player.global_position = d1[2] + playerOffset
			Global.player.controlMov = true
			d1[0].get_node("AnimationPlayer").play("Close")
			yield(d1[0].get_node("AnimationPlayer"), "animation_finished")
			d1[0].get_node("Interactable").open = false
			return
