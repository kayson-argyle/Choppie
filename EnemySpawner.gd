tool
extends Sprite

class_name enemySpawner

export var enemyType = ""
export var time = 5.0
export var radius = 10.0
export var squish = true
export var launchSpeed = 20
var timer = 0
onready var enemy = load("res://" + enemyType + ".tscn")
var random = RandomNumberGenerator.new()
export var spawnLimit = 6

func _ready():
	random.randomize()

func _process(delta):
	if not Engine.editor_hint:
		if (Global.player.global_position - global_position).length() < radius:
			timer += delta
			if timer > time:
				if $Enemies.get_child_count() < spawnLimit:
					timer = 0
					$AnimationPlayer.play("Squish")
	
	else:
		$RayCast2D.cast_to = $Position2D.position
		$Radius.shape.radius = radius

func spawn():
		Sounds.playPosSound("res://bubblePop.wav", global_position, 350, 0, 0, 0.7)
		var e = enemy.instance()
		$Enemies.add_child(e)
		e.global_position = $SpawnPoint.global_position
		e.linear_velocity = ($Position2D.position.rotated(rotation) + Vector2(random.randf_range(-10, 10), random.randf_range(-10, 10))) * launchSpeed
		
