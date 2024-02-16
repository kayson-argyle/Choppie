extends Node2D

class_name Level

export var music = ""
export var respawnLocation = ""
var respawnPos = null

func _ready():
	Music.playMusic(music)
	Global.respawnScene = respawnLocation
