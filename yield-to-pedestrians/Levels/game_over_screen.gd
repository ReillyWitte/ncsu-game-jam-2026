extends CanvasLayer


@onready var dead_num: Label = $NewsPaper/DeadNum
@onready var score: Label = $NewsPaper/Score

@onready var color_rect: ColorRect = $ColorRect
@onready var newspaper: TextureRect = $NewsPaper


func _ready():
	self.hide()

func game_end() -> void:
	
	dead_num.text =str(Global.kill_count) 
	score.text = str(Global.player_score)
	
	get_tree().paused = true
	self.show()
	
	var ending_animation_tween = create_tween()
	# Change background
	ending_animation_tween.tween_property(color_rect, "color:a", 1, 1)
	
	# Wait 0.5 seconds
	ending_animation_tween.tween_interval(0.5)
	
	# Rotate and slide in
	ending_animation_tween.parallel().tween_property(newspaper,"rotation_degrees",-9,1)
	ending_animation_tween.parallel().tween_property(newspaper,"position",Vector2(400,325),1)
	
	


func _on_retry_pressed() -> void:
	get_tree().paused = false
	Global.reset_globals()
	self.hide()
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	self.hide()
	get_tree().change_scene_to_file("res://Levels/title_screen.tscn")
