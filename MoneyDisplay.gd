extends Label

func _ready():
	Global.register("money", self)
	changeMoneyAmount(0)
	



func changeMoneyAmount(amount):
	Global.moneyAmount += amount
	text = "$" + str(Global.moneyAmount)
