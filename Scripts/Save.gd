extends Node

var data = {}

func _ready():
	var new = File.new()
	new.open("user://Save/TempSave.json", File.WRITE)
	var old = File.new()
	old.open("res://Data/Save.json", File.READ)
	var text = old.get_as_text()
	old.close()
	data = parse_json(text)
