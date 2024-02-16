extends TreeBoi

func _ready():
	totalHits = 7

signal seedsFull

func _process(_delta):
	if totalHits % hitsForSeed == 0 && $SeedHolder.get_child_count() >= seedLimit:
		emit_signal("seedsFull")
