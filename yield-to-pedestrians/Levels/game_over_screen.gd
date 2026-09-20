extends CanvasLayer


@onready var dead_num: Label = $NewsPaper/DeadNum
@onready var score: Label = $NewsPaper/Score

@onready var color_rect: ColorRect = $ColorRect
@onready var newspaper: TextureRect = $NewsPaper
@onready var center_container: CenterContainer = $CenterContainer

@onready var old_audio_db: float
@onready var sfx_index: float

@onready var end_music: AudioStreamPlayer2D = $end_screen
@onready var gameplay_music: Node2D = $"../CharacterBody2D/GameplayMusic"


func _ready():
	end_music.stop()

func game_end() -> void:
	dead_num.text =str(Global.kill_count) 
	score.text = str(Global.player_score)
	
	get_tree().paused = true
	self.show()
	
	
	end_music.play()
	
	var ending_animation_tween = create_tween()
	# Change background
	ending_animation_tween.tween_property(color_rect, "color:a", 1, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Mute SFX
	sfx_index = AudioServer.get_bus_index("SFX")
	old_audio_db = AudioServer.get_bus_volume_db(sfx_index)
	AudioServer.set_bus_volume_db(sfx_index,-63)
	
	# Wait 0.5 seconds
	ending_animation_tween.tween_interval(0.5)
	
	# Rotate and slide in
	ending_animation_tween.parallel().tween_property(newspaper,"rotation_degrees",-9,1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	ending_animation_tween.parallel().tween_property(newspaper,"position",Vector2(400,325),1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	ending_animation_tween.tween_property(center_container,"modulate:a",1,1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	



func _on_retry_pressed() -> void:
	get_tree().paused = false
	Global.reset_globals()
	self.hide()
	get_tree().reload_current_scene()
	AudioServer.set_bus_volume_db(sfx_index,old_audio_db)


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	self.hide()
	get_tree().change_scene_to_file("res://Levels/title_screen.tscn")
	AudioServer.set_bus_volume_db(sfx_index,old_audio_db)
