extends Node

onready var player = get_node("Player")
onready var camera = player.get_node("CameraHolder/Camera2D")
onready var cameraControl = camera.get_node("CanvasLayer/Control")
onready var inventory = cameraControl.get_node("Inventory")
onready var oak = get_node("Sizeable Oak")
