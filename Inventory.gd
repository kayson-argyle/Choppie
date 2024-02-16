extends Sprite

func _ready():
	Global.inventory = self

func getSelection():
	return($Slots.get_child($Selector.pos))

func changeItemAmount(type, amount):
	for childNum in get_child(0).get_child_count():
		var selectedPoint = get_child(0).get_child(childNum)
		if selectedPoint.frame != 0 and Global.seedNames[selectedPoint.frame] == type:
			if selectedPoint.amount + amount > Global.seedData[Global.seedNames[selectedPoint.frame]]["Limit"]:
				return false
			else:
				selectedPoint.changeAmount(amount)
				return true
		elif childNum == get_child(0).get_child_count() - 1:
			for childNum2 in get_child(0).get_child_count():
				var selectedPoint2 = get_child(0).get_child(childNum2)
				if selectedPoint2.amount == 0 or selectedPoint2.frame == 0:
					selectedPoint2.frame = Global.seedNames.find(type)
					selectedPoint2.changeAmount(amount)
					return true

func viewItems(var type = true, var amount = true):
	var items = []
	for childNum in get_child(0).get_child_count():
		var selectedPoint = get_child(0).get_child(childNum)
		var adder = []
		if type:
			adder.append(selectedPoint.frame)
		if amount:
			adder.append(selectedPoint.amount)
		items.append(adder)
	return items

func resetInventory():
	for child in $Slots.get_children():
		child.amount = 0
		child.frame = 0
