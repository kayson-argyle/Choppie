extends Chunks


var x = [preload("res://Explosion.tscn"), preload("res://SnipeFireball.tscn"), preload("res://FragonTornado.tscn"), preload("res://TornadoStarter.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready():
	#Sounds.playPosSound("res://waterfall.wav", $Waterfall/Mist.global_position, 200)
	Music.playMusic("res://Tiny Jelly.ogg")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		Global.player.damage(1000)
