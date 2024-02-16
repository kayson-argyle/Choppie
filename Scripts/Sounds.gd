extends AudioStreamPlayer

var random = RandomNumberGenerator.new()
var shiftSound = false

func _ready():
	random.randomize()
	var node = Node.new()
	add_child(node)
	node.name = "PosSound"

func playSound(sound):
	if not playing:
		stream = load(sound)
		play()
	else:
		for i in get_children():
			if i.name != "PosSound":
				if not i.playing:
					i.stream = load(sound)
					i.play()
					return
		var audio = AudioStreamPlayer.new()
		add_child(audio)
		audio.stream = load(sound)
		audio.play()
		
func playPosSound(sound, pos, var dist = 100, var db = 0, var variation = 0.2, var pitchGain = 1, var falloff = 1.5):
		if shiftSound:
			pos += Global.camera.global_position - Global.player.global_position
		if dist <= 0:
			dist = 0.01
		for i in $PosSound.get_children():
			if not i.playing:
				i.stream = load(sound)
				i.bus = "Sounds"
				i.global_position = pos
				
				i.max_distance = dist
				i.volume_db = db
				i.pitch_scale = random.randf_range(pitchGain + variation/2, pitchGain - variation/2)
				i.attenuation = falloff
				i.play()
				return i
		var audio = AudioStreamPlayer2D.new()
		$PosSound.add_child(audio)
		audio.stream = load(sound)
		audio.global_position = pos
		audio.max_distance = dist
		audio.bus = "Sounds"
		audio.volume_db = db
		audio.pitch_scale = random.randf_range(pitchGain + variation/2, pitchGain - variation/2)
		audio.attenuation = falloff
		audio.play()
		return audio
