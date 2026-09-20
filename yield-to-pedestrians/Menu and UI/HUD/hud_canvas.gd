extends CanvasLayer

@onready var gas_needle: Sprite2D = $Needle_Sprite
@onready var score_label: Label = $Fuel_Gauge_Sprite/Label

func _process(delta: float) -> void:
	gas_needle.rotation = (PI/100) * (Global.fullGasLevel - Global.currentGasLevel)
	score_label.text = str(Global.player_score)
