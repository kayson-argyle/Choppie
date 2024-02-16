extends Node2D

class_name Chunks

onready var player = $Player
var playerPos
export var chunkSize = 300
var currentChunk
var Permutations9x9 = [Vector2(1, 1), Vector2(1, 0), Vector2(1, -1), Vector2(0, -1), Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1), Vector2(0, 1), Vector2(0, 0)]
var chunkPositions = []
var chunkRef = []

func _ready():
	for i in get_children():
		if i.get_class() == "Package":
			for j in i.get_children():
				i.remove_child(j)
				add_child(j)
			i.queue_free()
	for i in get_children():
		if i != player and i.get_class() != "TileMap" and i.name != "Loader" and i.get_class() != "ParallaxBackground":
			var chunkPos = Vector2(floor(i.position.x / chunkSize), floor(i.position.y / chunkSize))
			var j = chunkPositions.find(chunkPos)
			remove_child(i)
			if j != -1:
				chunkRef[j].add_child(i)
			else:
				chunkPositions.append(chunkPos)
				var chunky = Node2D.new()
				chunkRef.append(chunky)
				chunky.add_child(i)


func chunkEntered(location):
	var loadedChunks = []
	for perm in Permutations9x9:
		var chunkLocation = location + perm
		var chunkNumber = chunkPositions.find(chunkLocation)
		if chunkNumber != -1:
			var chunk = chunkRef[chunkNumber]
			loadedChunks.append(chunk)
			if chunk.get_parent() == null:
				add_child(chunk)
	
	for i in get_children():
		if i != player and i.get_class() != "TileMap" and i.name != "Loader" and i.get_class() != "ParallaxBackground" and i.name != "Ragdoll":
			if not i in loadedChunks:
				for j in i.get_children():
					var jLo = Vector2(floor(j.position.x / chunkSize), floor(j.position.y / chunkSize))
					if jLo != chunkPositions[chunkRef.find(i)]:
						i.remove_child(j)
						var newChunkIndex = chunkPositions.find(jLo)
						if newChunkIndex == -1:
							chunkPositions.append(jLo)
							var chunky = Node2D.new()
							chunkRef.append(chunky)
							chunky.add_child(j)
						else:
							chunkRef[chunkPositions.find(jLo)].add_child(j)
				remove_child(i)

func _physics_process(_delta):
	playerPos = player.global_position
	var location = Vector2(floor(playerPos.x / chunkSize), floor(playerPos.y / chunkSize))
	if location != currentChunk:
		currentChunk = location
		chunkEntered(location)

func insertNode(node):
	var nodePos = Vector2(floor(node.position.x / chunkSize), floor(node.position.y / chunkSize))
	var newChunkIndex = chunkPositions.find(nodePos)
	if newChunkIndex == -1:
		chunkPositions.append(nodePos)
		var chunky = Node2D.new()
		chunkRef.append(chunky)
		chunky.add_child(node)
	else:
		chunkRef[chunkPositions.find(nodePos)].add_child(node)
