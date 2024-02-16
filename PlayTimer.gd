extends Label


func _process(delta):
	text = "You have survived for " + str(int(Global.survivalTime)) + " seconds"
	Global.survivalTime += delta
