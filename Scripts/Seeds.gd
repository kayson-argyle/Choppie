extends Label
onready var Tree = get_node("/root/World/Sizeable Oak")
	
func _process(_delta):
	set_text(str(Tree.get("acornAmount")) + " Acorns")
