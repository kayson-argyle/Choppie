extends Travel

func _on_RockCluster_destroyed():
	for i in 2:
		get_parent().set_cell(-1, -i-2, 0, false, false, false, Vector2(13, 1))
	get_parent().set_cell(-1, -1, 0, false, false, false, Vector2(16, 2))
	visible = true
	$SecretTunnel.collision_layer = 6


func _on_Area2D_body_entered(body):
	if "Player" in body.get_name():
		interact()
