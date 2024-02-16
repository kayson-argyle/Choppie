extends AudioStreamPlayer

var otherOne = AudioStreamPlayer.new()
var tween = Tween.new()
var currentPlayer = self
var muted = false
var fadeDir = "in"

func _ready():
	add_child(otherOne)
	otherOne.volume_db = -80
	add_child(tween)

func playMusic(music, var crossfadeTime = 1.5):
	muted = false
	var lM = load(music)
	if currentPlayer == self and not playing:
		if lM != stream:
			stream = lM
			play()
	elif currentPlayer == self and fadeDir == "in":
		currentPlayer = otherOne
		
		if lM != otherOne.stream:
			otherOne.stream = lM
			otherOne.play()
		
		tween.interpolate_property(self, "volume_db", volume_db, -80, crossfadeTime, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		tween.interpolate_property(otherOne, "volume_db", otherOne.volume_db, 0, crossfadeTime, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		tween.start()
		fadeDir = "out"
	elif currentPlayer == otherOne and fadeDir == "out":
		currentPlayer = self
		
		if lM != stream:
			stream = lM
			play()
		
		tween.interpolate_property(otherOne, "volume_db", otherOne.volume_db, -80, crossfadeTime, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		tween.interpolate_property(self, "volume_db", volume_db, 0, crossfadeTime, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		tween.start()
		fadeDir = "in"

		
func mute(m, var fadeTime = 1.5):
	muted = m
	if muted:
		tween.interpolate_property(self, "volume_db", volume_db, -80, fadeTime, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		tween.interpolate_property(otherOne, "volume_db", otherOne.volume_db, -80, fadeTime, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.interpolate_property(self, "volume_db", volume_db, 0, fadeTime, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		tween.interpolate_property(otherOne, "volume_db", otherOne.volume_db, 0, fadeTime, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		tween.start()
