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

var SFX_Deer_VoiceLines: Array[Resource] = [
	preload("res://Music and Sounds/SFX/Deer/Antlertained.mp3"),
	preload("res://Music and Sounds/SFX/Deer/BambisMom.mp3"),
	preload("res://Music and Sounds/SFX/Deer/BuckYeah.mp3"),
	preload("res://Music and Sounds/SFX/Deer/DoeDoeDoe.mp3"),
	preload("res://Music and Sounds/SFX/Deer/GetBucked.mp3"),
	preload("res://Music and Sounds/SFX/Deer/GetDeercimated.mp3"),
	preload("res://Music and Sounds/SFX/Deer/IHateDaylightSavings.mp3"),
	preload("res://Music and Sounds/SFX/Deer/MessWithTheDeer.mp3"),
	preload("res://Music and Sounds/SFX/Deer/MountYouOnMyWall.mp3"),
	preload("res://Music and Sounds/SFX/Deer/OhDeer.mp3"),
	preload("res://Music and Sounds/SFX/Deer/OpenSeason.mp3"),
	preload("res://Music and Sounds/SFX/Deer/ShoesOnTheOtherHoof.mp3"),
	preload("res://Music and Sounds/SFX/Deer/ThisIsFawn.mp3"),
]
var SFX_Person_VoiceLines: Array[Resource] = [
	preload("res://Music and Sounds/SFX/People/getAway.mp3"),
	preload("res://Music and Sounds/SFX/People/GetAwayFromMe.mp3"),
	preload("res://Music and Sounds/SFX/People/IHaveAFamily.mp3"),
	preload("res://Music and Sounds/SFX/People/PleaseNo.mp3"),
	preload("res://Music and Sounds/SFX/People/Stop.mp3"),
	preload("res://Music and Sounds/SFX/People/Wait.mp3"),
	preload("res://Music and Sounds/SFX/People/WaitImVegitarian.mp3"),
]
var SPLAT = preload("res://Music and Sounds/SFX/universfield-wet-squelch-impact-352302.mp3")
var MISTAKE = preload("res://Music and Sounds/SFX/lesiakower-error-mistake-sound-effect-incorrect-answer-437420.mp3")
var GLUG = preload("res://Music and Sounds/SFX/glug-glug-sound-effects_vktLrAhx.mp3")
var TURBO = preload("res://Music and Sounds/SFX/spinopel-turbo-flutter-336362_NdZIkmcY.mp3")

var MenuMusic = preload("res://Music and Sounds/Music/main_menu_music.mp3")
var gameMusicIntro = preload("res://Music and Sounds/Music/intro_gameplay_song.mp3")
var gameMusicLoop = preload("res://Music and Sounds/Music/gameplay_loop_music.mp3")
var endMusic = preload("res://Music and Sounds/Music/endscreen_music.mp3")

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


func play_Music(stream: AudioStream, volume_db: float = 0.0, pitch_variation: float = 0.0,loop = false) -> void:
	# Each call gets its own player so overlapping sounds don't cut each other off
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	# A little random pitch keeps repeated sounds from feeling robotic
	player.pitch_scale = randf_range(1.0 - pitch_variation, 1.0 + pitch_variation)
	# Enable looping if requested
	if loop:
		var looped_stream := stream.duplicate()
		if looped_stream is AudioStreamWAV:
			looped_stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		elif looped_stream is AudioStreamOggVorbis:
			looped_stream.loop = true
		player.stream = looped_stream
	# Send it to the SFX bus if it exists, otherwise fall back to Master
	if AudioServer.get_bus_index("Music") != -1:
		player.bus = "Music"
	add_child(player)
	# Clean up automatically when the sound ends
	player.finished.connect(player.queue_free)
	player.play()
	
