extends CanvasLayer

@onready var gas_needle: Sprite2D = $Needle_Sprite
@onready var score_label: Label = $Fuel_Gauge_Sprite/Label
@onready var fuel_light: AnimatedSprite2D = $"Fuel_Gauge_Sprite/Fuel Light"
@onready var gas_chime: AudioStreamPlayer2D = $"../CharacterBody2D/GameplayMusic/Gas Chime"


func _process(delta: float) -> void:
	gas_needle.rotation = (PI/100) * (Global.fullGasLevel - Global.currentGasLevel)
	score_label.text = str(Global.player_score)
	
	if Global.currentGasLevel/Global.fullGasLevel < 0.20:
		fuel_light.play("super on")
		gas_chime.pitch_scale = 2
		if !gas_chime.playing:
			gas_chime.play()
	elif Global.currentGasLevel/Global.fullGasLevel < 0.40:
		fuel_light.play("on")
		gas_chime.pitch_scale = 1
		if !gas_chime.playing:
			gas_chime.play()
	else: 
		fuel_light.play("off")
		gas_chime.stop()
		
