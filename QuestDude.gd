extends Npc

var run = false
var timer = 1
var path
var sizeTimer = 0
var reared = false
var rearing = false

func _ready():
	if WorldVars.traveledToCamp:
		queue_free()
	else:
		$"../Sign".canInteract = false

func action():
	expression = 0
	$Area2D.collision_mask = 0
	
	run = true
	path = get_tree().get_current_scene().find_node("KnightPath")
	
	$"../Sign".canInteract = true

func _process(delta):
	if run:
		if reared:
			z_index = -2
			sizeTimer += delta * 0.2
			sizeTimer = clamp(sizeTimer, 0, 1)
			timer += delta * 0.002
			global_position = lerp(global_position, path.global_position - path.get_parent().get_parent().get_parent().get_parent().scroll_offset, sizeTimer)
			path.unit_offset += delta * 0.2
			$Horse.volume_db = -10 - path.unit_offset * 24
			if path.unit_offset == 1:
				$AnimationPlayer2.play("Idle")
			else:
				scale *= 1/timer
		
		elif not rearing:
			$AnimationPlayer2.play("Rear")
			rearing = true
		
		elif not $AnimationPlayer2.is_playing():
			reared = true
			$AnimationPlayer2.play("Run")
