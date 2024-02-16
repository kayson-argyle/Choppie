extends AnimatedSprite

func _process(_delta):
	scale.x = Global.currentBossHealth / Global.bossHealth
	if Global.currentBossHealth == 0:
		visible = false
	else:
		visible = true
