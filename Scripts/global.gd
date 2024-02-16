extends Node

var score = 0
var choppieHealth = 1000.0
var gravity = 300
var gravityScale = gravity / 300
var bossHealth = 1000.0
var currentBossHealth = 1000.0
var playerStartPos = Vector2.ZERO
var seedCounts = []
var seedData = {}
var seedNames = ["None", "Acorn", "Pinecone", "Orange", "Apple", "Watermelon", "Mango", "Nuke", "Bat Wing", "Cherry", "Squid Egg", "Beetler Shell", "Rune Rock", "Stick"]
var doorPositions = []
var doorDir = "in"
var playerItems = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
var inChange = false
var playerSetPos = false
var playerSetPosLoc = Vector2()
var doorId = ""
var randomplayerdata ={}
var isChopping = false
var canGetWood = true
var survivalTime = 0
var respawnScene
var itemSelectorPos = 0
var moneyAmount = 0

var money
var player
var tree
var camera
var dialogue
var shoppe
var inventory

func cameraShake(small_shake_lower_is_faster : float, big_shake_higher_is_faster: float, time: float, amplitude : float) -> void:
	camera.shake(small_shake_lower_is_faster, big_shake_higher_is_faster, time, amplitude)
	
func changeItemAmount(type, amount):
	return inventory.changeItemAmount(type, amount)

func register(varName, ref):
	set(varName, ref)

func sigmoid(x):
	return ((1 / (1 + pow(VisualScriptMathConstant.MATH_CONSTANT_E, x - 1))) - 0.5) * 2

func _init():
	process_priority = 1

func _ready():
	var seedJson = File.new()
	seedJson.open("res://Data/SeedLoader.json", File.READ)
	var seedAsText = seedJson.get_as_text()
	seedJson.close()
	seedData = parse_json(seedAsText)
	for values in seedData.values():
		seedCounts.append(0)
	#seedNames = seedData.values()
	
func changeScene(path, time : float = 1, setPlayerPos = false, playerPos = Vector2(), var door = ""):
	doorId = door
	player.saveSeeds()
	if not inChange:
		inChange = true
		player.get_node("CameraHolder/Camera2D/CanvasLayer/Control/CanvasLayer/Transition").transition("out", time)
		yield(get_tree().create_timer(time), "timeout")
		Interact.reset()
		TeleportDoors.reset()
		if setPlayerPos:
			playerSetPos = true
			playerSetPosLoc = playerPos
		else:
			playerSetPos = false
	# warning-ignore:return_value_discarded
		get_tree().change_scene(path)
		inChange = false

func changeMoneyAmount(amount):
	money.changeMoneyAmount(amount)
	


