extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var type = get_parent().get_parent().get_parent().currency
	var tex = load("res://Items/" + type + ".png")
	texture = tex
	var outTex = load("res://Items/" + type + "Outline.png")
	$Outline.texture = outTex


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
