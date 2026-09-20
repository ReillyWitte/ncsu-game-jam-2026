extends CanvasLayer

@onready var score: Label = $Score
@onready var dead_num: Label = $DeadNum


func _ready():
	self.hide()

func _process(delta: float) -> void:
	if Global.currentGasLevel <= 0:
		
		
		dead_num.text =str(Global.kill_count) 
		score.text = str(Global.player_score)
		
		get_tree().paused = true
		self.show()



func _on_retry_pressed() -> void:
	get_tree().paused = false
	Global.reset_globals()
	self.hide()
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	self.hide()
	get_tree().change_scene_to_file("res://Levels/title_screen.tscn")
