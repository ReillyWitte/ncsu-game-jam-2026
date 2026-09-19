extends Node2D

@export var target_position: Vector2

func _ready() -> void:
	Global.numGas = Global.numGas + 1
	print("Gas number ", Global.numGas, " created")
	
func _process(delta: float) -> void:
	$Sprite2D.global_rotation = -get_canvas_transform().get_rotation()

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Body entered: ", body.name)
	
	if body is CharacterBody2D:
		#print("Gas collected")
		Global.numGas = Global.numGas - 1
		#print(Global.numGas, " gas left")
		Global.currentGasLevel = Global.currentGasLevel + 20
		if Global.currentGasLevel > Global.fullGasLevel:
			Global.currentGasLevel = Global.fullGasLevel
		queue_free()
