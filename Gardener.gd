extends Npc

func _ready():
	Global.dialogue.connect("optionPicked", self, "optionSelected")
	Global.dialogue.connect("closed", self, "closed")
	if WorldVars.npcData["Gardener"]["plantedMango"]:
		call_deferred("plantMango")

func interact():
	if  WorldVars.npcData["Gardener"]["hasMet"]:
		if Global.inventory.viewItems(true, false).has([4]) and not WorldVars.npcData["Gardener"]["hasApple"]:
			messageName = "Apple"
		elif Global.inventory.viewItems(true, false).has([6]) and not WorldVars.npcData["Gardener"]["hasMango"] and WorldVars.npcData["Gardener"]["hasApple"]:
			messageName = "Mango"
		else:
			pass
	else:
		messageName = "Greeting"
	.interact()


func closed():
	if messageName == "Greeting":
		WorldVars.npcData["Gardener"]["hasMet"] = true
		messageName = "Generic"
	if messageName == "Apple Exchange":
		messageName = "Generic"
	if messageName == "Mango Exchange":
		messageName = "Mango Tree"


func optionSelected(button, _dialogueNum):
	if messageName == "Apple":
		if button == 1:
			messageName = "Apple Exchange"
			Global.dialogue.open(data[npcName][messageName], false)
			Global.changeItemAmount("Apple", -1)
			WorldVars.npcData["Gardener"]["hasApple"] = true
			
		if button == 2:
			messageName = "Apple Decline"
			Global.dialogue.open(data[npcName][messageName], false)
	
	if messageName == "Mango":
		if button == 1:
			messageName = "Mango Exchange"
			Global.dialogue.open(data[npcName][messageName], false)
			Global.changeItemAmount("Mango", -1)
			WorldVars.npcData["Gardener"]["hasMango"] = true
			goTo(426)
			
		if button == 2:
			messageName = "Mango Decline"
			Global.dialogue.open(data[npcName][messageName], false)

func arrivedDestination():
	.arrivedDestination()
	if messageName == "Mango Tree":
		WorldVars.npcData["Gardener"]["plantedMango"] = true
		plantMango()

func plantMango():
	var mango = load("res://MangoTree.tscn")
	var m = mango.instance()
	get_tree().get_current_scene().add_child(m)
	m.global_position = Vector2(405, 1)
	
