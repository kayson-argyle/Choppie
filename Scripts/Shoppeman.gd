extends Npc


func _ready():
	npcName = "Shoppeman"
	expression = expressions.NONE

func action():
	Global.shoppe.open()

func stopAction():
	Global.shoppe.close()
	dialogueNumber = 0
	talking = false
	justStoppedTalking = true
