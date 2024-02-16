extends Label
var wood = 0
onready var cherryTree = get_node("/root/World/Sizeable Oak")
	
func _process(_delta):
	set_text(str(cherryTree.get("oakWood")) + " oak wood")
	
