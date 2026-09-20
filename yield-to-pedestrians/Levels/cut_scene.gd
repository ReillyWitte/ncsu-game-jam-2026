extends Control

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer

func on_video_finish():
	get_tree().change_scene_to_file("res://Levels/Tutorial.tscn")
