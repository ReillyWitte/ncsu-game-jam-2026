extends Node

var SFX_SCREAMS: Array[Resource] = [
	preload("res://Music and Sounds/SFX/Screams/Oof.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Ouch.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Ow.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream1.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream2.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream3.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream4.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream5.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream6.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream7.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream8.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream9.mp3"),
	preload("res://Music and Sounds/SFX/Screams/Scream10.mp3")
]

func play_sfx(stream: AudioStream, volume_db: float = 0.0, pitch_variation: float = 0.0) -> void:
	# Each call gets its own player so overlapping sounds don't cut each other off
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	# A little random pitch keeps repeated sounds from feeling robotic
	player.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
	# Send it to the SFX bus if it exists, otherwise fall back to Master
	if AudioServer.get_bus_index("SFX") != -1:
		player.bus = "SFX"
	add_child(player)
	# Clean up automatically when the sound ends
	player.finished.connect(player.queue_free)
	player.play()
