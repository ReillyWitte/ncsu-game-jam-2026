extends Node2D

var signed_gain

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("score_popup"):
		if node != self:
			node.queue_free()
	add_to_group("score_popup")
	kill_after_time()
	var point_gain = Global.last_point_gain
	if point_gain > 0:
		signed_gain = "+" + str(point_gain)
	else:
		signed_gain = str(point_gain)
	$CanvasLayer/Label2.text = signed_gain + " points"


func kill_after_time(time: int = 2) -> void:
	await get_tree().create_timer(time).timeout
	queue_free()
