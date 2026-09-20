extends Node2D

@onready var main_loop: AudioStreamPlayer2D = %mainLoop
@onready var intro_player: AudioStreamPlayer2D = $introPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro_player.play()

func play_main() -> void:
	main_loop.play()


func fade_out():
	var tween = create_tween()
	tween.tween_property(main_loop,"volume_db",-63,1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
