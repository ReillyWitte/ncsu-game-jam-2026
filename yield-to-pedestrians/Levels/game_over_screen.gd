extends CanvasLayer

@onready var score: Label = $Score
@onready var dead_num: Label = $DeadNum
@onready var color_rect: ColorRect = $ColorRect


func _ready():
	self.hide()

func game_end() -> void:
	
	dead_num.text =str(Global.kill_count) 
	score.text = str(Global.player_score)
	
	get_tree().paused = true
	self.show()
	
	var background_fade = create_tween()
	background_fade.tween_property(color_rect, "color:a", 1, 1)
	
	


func _on_retry_pressed() -> void:
	get_tree().paused = false
	Global.reset_globals()
	self.hide()
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	self.hide()
	get_tree().change_scene_to_file("res://Levels/title_screen.tscn")
