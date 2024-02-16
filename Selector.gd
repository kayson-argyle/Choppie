extends Sprite

var pos = 0
var scroll = 0

func _ready():
	setPos(Global.itemSelectorPos)

func _process(_delta):
	for i in 6:
		if Input.is_action_just_pressed(str(i+1)):
			setPos(i)
	
	if Input.is_action_just_pressed("seed_left"):
		shiftPos(-1)
	if Input.is_action_just_pressed("seed_right"):
		shiftPos(1)

func shiftPos(dir):
	pos += dir
	pos = clamp(pos, 0, 5)
	Global.itemSelectorPos = pos
	position.x += 17 * dir
	position.x = clamp(position.x, -42, 43)

func setPos(num):
	pos = num
	pos = clamp(pos, 0, 5)
	Global.itemSelectorPos = pos
	position.x = -42 + 17 * pos

func _input(event):
	if event is InputEventMouseButton:
		var oldScroll = floor(scroll)
		if event.button_index == BUTTON_WHEEL_UP:
			scroll -= 0.5
		elif event.button_index == BUTTON_WHEEL_DOWN:
			scroll += 0.5
		scroll = clamp(scroll, 0, 5)
		if oldScroll != floor(scroll):
			setPos(floor(scroll))
