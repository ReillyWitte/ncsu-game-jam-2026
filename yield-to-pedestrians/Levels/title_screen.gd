extends Node2D

enum TITLE_SCREEN_STATE {MAIN_SCREEN, TUTORIAL1, TUTORIAL2}
var state = TITLE_SCREEN_STATE.MAIN_SCREEN

func _ready():
	$Tutorial1/ImageTut1.visible = false
	$Tutorial2/ImageTut2.visible = false
	$CenterContainer/SettingsMenu/mainvolslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$CenterContainer/SettingsMenu/musicslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$CenterContainer/SettingsMenu/sfxvolslider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func _on_play_pressed() -> void:
	state = TITLE_SCREEN_STATE.TUTORIAL1
	$Tutorial1/ImageTut1.visible = true


func _on_settings_pressed() -> void:
	$CenterContainer/MainButtons.visible = false
	$CenterContainer/SettingsMenu.visible = true

func _on_credits_pressed() -> void:
	$CenterContainer/MainButtons.visible = false
	$CenterContainer/CreditsMenu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$CenterContainer/MainButtons.visible = true
	$CenterContainer/SettingsMenu.visible = false
	$CenterContainer/CreditsMenu.visible = false

func _process(delta: float) -> void:
	get_input1()

func get_input1():
	if Input.is_action_just_pressed("click") and state == TITLE_SCREEN_STATE.TUTORIAL1:
			$Tutorial1/ImageTut1.visible = false
			$Tutorial2/ImageTut2.visible = true
			state = TITLE_SCREEN_STATE.TUTORIAL2
	elif Input.is_action_just_pressed("click") and state == TITLE_SCREEN_STATE.TUTORIAL2:
		get_tree().change_scene_to_file("res://Levels/root_node.tscn")



func get_input2():
	if Input.is_anything_pressed() and $Tutorial2/ImageTut2.visible == true:
			get_tree().change_scene_to_file("res://Levels/root_node.tscn")

func _on_mainvolslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"),value)

func _on_musicslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),value)


func _on_sfxvolslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"),value)
