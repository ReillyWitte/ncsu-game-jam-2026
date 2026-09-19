extends Node2D

func _ready() -> void:
	Global.numNitrous = Global.numNitrous + 1
	print("Nitro number ", Global.numNitrous, " created")
	
func _process(delta: float) -> void:
	$Sprite2D.global_rotation = -get_canvas_transform().get_rotation()

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Body entered: ", body.name)
	
	if body is CharacterBody2D and body.is_in_group("player"):
		#print("Gas collected")
		Global.numNitrous = Global.numNitrous - 1
		#print(Global.numGas, " gas left")
		body.speed_boost()
		queue_free()
