extends Interactable

var timer = 0

func _process(delta):
	if timer != 0:
		timer += delta
		if timer > 2:
			Global.dialogue.close()
			timer = 0
			
func interact():
	var anim = true
	if timer != 0:
		anim = false
	Global.dialogue.open({"0" : "this feature is not implemented yet"}, anim)
	timer = 0.01
