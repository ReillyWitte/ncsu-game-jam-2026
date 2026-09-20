extends Node2D

func _ready():
	$Tutorial1/ImageTut1.visible = false
	$Tutorial2/ImageTut2.visible = false

func _on_play_pressed() -> void:
	
	$Tutorial1/ImageTut1.visible = true
	await get_tree().create_timer(8.0).timeout
	$Tutorial1/ImageTut1.visible = false
	$Tutorial2/ImageTut2.visible = true
	await get_tree().create_timer(8.0).timeout
	
	get_tree().change_scene_to_file("res://Levels/root_node.tscn")

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
