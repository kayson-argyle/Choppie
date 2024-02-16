extends Timer




func _on_Music_timeout():
	$Ambiance.play()
	stop()
	wait_time = 140

	start()
	
