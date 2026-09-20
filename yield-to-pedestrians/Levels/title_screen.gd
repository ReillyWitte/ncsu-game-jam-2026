extends Node2D

func _ready() -> void:
	$CenterContainer/MainButtons/Play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/root_node.tscn")

func _on_settings_pressed() -> void:
	$CenterContainer/MainButtons.visible = false
	$CenterContainer/SettingsMenu.visible = true
	$CenterContainer/SettingsMenu/HSlider.grab_focus()

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
