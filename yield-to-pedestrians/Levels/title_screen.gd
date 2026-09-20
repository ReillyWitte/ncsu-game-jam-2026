extends Node2D

# state machine
enum TITLE_SCREEN_STATE {MAIN_SCREEN, TUTORIAL1, TUTORIAL2}
var state = TITLE_SCREEN_STATE.MAIN_SCREEN

func _ready():
	#audio
	$CenterContainer/SettingsMenu/mainvolslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$CenterContainer/SettingsMenu/musicslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$CenterContainer/SettingsMenu/sfxvolslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	$CenterContainer/MainButtons/Play.grab_focus()

#starts tutorial
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/cut_scene.tscn")
	# Ignore presses once the tutorial has started
	if state != TITLE_SCREEN_STATE.MAIN_SCREEN:
		return
	state = TITLE_SCREEN_STATE.TUTORIAL1
	$Tutorial1/ImageTut1.visible = true
	# Take focus off the button so accept doesn't press it again
	$CenterContainer/MainButtons/Play.release_focus()


#other buttons
func _on_settings_pressed() -> void:
	$CenterContainer/MainButtons.visible = false
	$CenterContainer/SettingsMenu.visible = true
	$CenterContainer/SettingsMenu/mainvolslider.grab_focus()

func _on_credits_pressed() -> void:
	$CenterContainer/MainButtons.visible = false
	$CenterContainer/CreditsMenu.visible = true
	$CenterContainer/CreditsMenu/Back.grab_focus()


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	$CenterContainer/MainButtons.visible = true
	$CenterContainer/SettingsMenu.visible = false
	$CenterContainer/CreditsMenu.visible = false
	$CenterContainer/MainButtons/Play.grab_focus()

func _process(delta: float) -> void:
	get_input1()

func get_input1():
	# Advance on mouse click or controller/keyboard accept
	var advance: bool = Input.is_action_just_pressed("click") or Input.is_action_just_pressed("ui_accept")
	if advance and state == TITLE_SCREEN_STATE.TUTORIAL1:
		$Tutorial1/ImageTut1.visible = false
		$Tutorial2/ImageTut2.visible = true
		state = TITLE_SCREEN_STATE.TUTORIAL2
	elif advance and state == TITLE_SCREEN_STATE.TUTORIAL2:
		get_tree().change_scene_to_file("res://Levels/root_node.tscn")


func get_input2():
	if Input.is_anything_pressed() and $Tutorial2/ImageTut2.visible == true:
			get_tree().change_scene_to_file("res://Levels/root_node.tscn")

#stupid sound stuff
func _on_mainvolslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"),value)

func _on_musicslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),value)


func _on_sfxvolslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"),value)
