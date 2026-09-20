extends Node

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
