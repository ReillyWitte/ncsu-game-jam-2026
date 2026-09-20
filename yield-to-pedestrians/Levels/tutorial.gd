extends Control

enum TITLE_SCREEN_STATE {MAIN_SCREEN, TUTORIAL1, TUTORIAL2}
@onready var tutorial_1: CanvasLayer = $Tutorial1
@onready var tutorial_2: CanvasLayer = $Tutorial2

var state

func _ready() -> void:
	state = TITLE_SCREEN_STATE.TUTORIAL1

# click through toutorial
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and state == TITLE_SCREEN_STATE.TUTORIAL1:
			state = TITLE_SCREEN_STATE.TUTORIAL2
			tutorial_1.visible = false
			tutorial_2.visible = true
	elif Input.is_action_just_pressed("click") and state == TITLE_SCREEN_STATE.TUTORIAL2:
		get_tree().change_scene_to_file("res://Levels/root_node.tscn")

func get_input2():
	if Input.is_anything_pressed() and $Tutorial2/ImageTut2.visible == true:
			get_tree().change_scene_to_file("res://Levels/root_node.tscn")
