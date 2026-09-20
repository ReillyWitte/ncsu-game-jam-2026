extends Node2D


func _ready() -> void:
	for node in get_tree().get_nodes_in_group("combo_popup"):
		if node != self:
			node.queue_free()
	add_to_group("combo_popup")
	kill_after_time()
	$CanvasLayer/Label.text = str(Global.last_multiplier) + "x" + "\n" + "Combo"


func kill_after_time(time: int = 2) -> void:
	await get_tree().create_timer(time).timeout
	queue_free()
