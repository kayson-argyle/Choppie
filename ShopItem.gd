extends Interactable

export var type = "Watermelon"

var random = RandomNumberGenerator.new()
var timer = 0
var pos
var speed
export var price = 0
export var currency = "Acorn"
var buyable = false
var correspondingItem

var item = preload("res://Item.tscn")

func _ready():
	pos = global_position.y
	random.randomize()
	speed = random.randf_range(3, 4)
	timer += random.randf_range(0, 3)
	var tex = load("res://Items/" + type + ".png")
	texture = tex
	var outTex = load("res://Items/" + type + "Outline.png")
	$Outline.texture = outTex
	$Bubble/Container/Label.text = str(price)
	#Global.player.connect("thrown", self, "checkInventory")
	
func interact():
	checkInventory()
	if buyable:
		if Global.inventory.changeItemAmount(type, 1):
			if currency == "Money":
				Global.changeMoneyAmount(-price)
			$Money/AnimationPlayer.stop()
			$Money/AnimationPlayer.play("Splash")
			Sounds.playPosSound("res://coinSplash.wav", global_position)
		else:
			var inv = Global.player.inventory.viewItems()
			for i in inv.size():
				if inv[i][0] == Global.seedNames.find(type):
					Global.inventory.get_child(0).get_child(i).tooMany()

func select():
	$Bubble.visible = true
	$Bubble/Anim.play("Inflate")
	$Bubble/Anim.seek(0.0, true)
	checkInventory()

func deselect():
	$Bubble.visible = false

func _process(delta):
	timer += delta
	global_position.y = pos + sin(timer * speed) * 0.5
	
func checkInventory():
	var inv = Global.player.inventory.viewItems()
	if currency == "Money" and Global.moneyAmount >= price:
		buyable = true
		$Bubble/Container/Label.set("custom_colors/font_color", Color(0,1,0))
		return
	for i in inv.size():
		if inv[i][0] == Global.seedNames.find(currency):
			if inv[i][1] >= price:
				buyable = true
				$Bubble/Container/Label.set("custom_colors/font_color", Color(0,1,0))
				return
	$Bubble/Container/Label.set("custom_colors/font_color", Color(1,0,0))
	buyable = false
