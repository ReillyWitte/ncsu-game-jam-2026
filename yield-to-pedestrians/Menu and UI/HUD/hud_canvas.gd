extends CanvasLayer

@onready var gas_needle: Sprite2D = $Needle_Sprite
@onready var score_label: Label = $Fuel_Gauge_Sprite/Label
@onready var fuel_light: AnimatedSprite2D = $"Fuel_Gauge_Sprite/Fuel Light"

func _process(delta: float) -> void:
	gas_needle.rotation = (PI/100) * (Global.fullGasLevel - Global.currentGasLevel)
	score_label.text = str(Global.player_score)
	
	if Global.currentGasLevel/Global.fullGasLevel < 0.20:
		fuel_light.play("super on")
		print("super_on")
	elif Global.currentGasLevel/Global.fullGasLevel < 0.40:
		fuel_light.play("on")
		print("on")
	else: 
		fuel_light.play("off")
		print("off")
