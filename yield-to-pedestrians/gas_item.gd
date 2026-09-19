extends Node2D

@export var target_position: Vector2
var vector_difference
@onready var arrow: Sprite2D = $CanvasLayer/Sprite2D
@export var arrow_radius: float = 480
@export var arrow_x_multiplier: float = 1.85
@export var on_screen_margin: float = 10
var player_in_range: bool = false
# Distance at or below which the arrow is fully opaque (tune this)
@export var fade_near_distance: float = 400.0
# Distance at or beyond which the arrow is at its faintest; set near your big area's edge (tune this)
@export var fade_far_distance: float = 1200.0
# Faintest the arrow gets, so it never vanishes completely (0 = can fade to invisible)
@export_range(0.0, 1.0) var min_arrow_alpha: float = 0.2

func _ready() -> void:
	Global.numGas = Global.numGas + 1
	print("Gas number ", Global.numGas, " created")
	arrow.hide()
	
func _process(delta: float) -> void:
	$Sprite2D.global_rotation = -get_canvas_transform().get_rotation()
	if player_in_range:
		update_arrow()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("player"):
		#print("Gas collected")
		Global.numGas = Global.numGas - 1
		#print(Global.numGas, " gas left")
		Global.currentGasLevel = Global.currentGasLevel + 20
		if Global.currentGasLevel > Global.fullGasLevel:
			Global.currentGasLevel = Global.fullGasLevel
		queue_free()
		

func _on_area_2d_big_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		#arrow.show()

func _on_area_2d_big_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		arrow.hide()
		
func update_arrow() -> void:
	var canvas_xform: Transform2D = get_canvas_transform()
	var can_screen: Vector2 = canvas_xform * global_position
	var player_screen: Vector2 = canvas_xform * Global.player_position
	var direction: Vector2 = can_screen - player_screen
	
	# The visible screen area, pulled in by the margin so a half-visible can still gets an arrow
	var visible_rect: Rect2 = get_viewport_rect().grow(-on_screen_margin)
	# Can is in view, so the arrow isn't needed; check this before the length test below
	if visible_rect.has_point(can_screen):
		arrow.hide()
		return
	
	# World-space distance, so camera zoom and rotation don't affect the fade
	var distance: float = global_position.distance_to(Global.player_position)
	# 1.0 at the near distance, 0.0 at the far distance (inverse_lerp handles the reversed range)
	var closeness: float = clampf(inverse_lerp(fade_far_distance, fade_near_distance, distance), 0.0, 1.0)
	# Blend from the faintest alpha up to fully opaque
	arrow.modulate.a = lerpf(min_arrow_alpha, 1.0, closeness)
	
	arrow.show()
	
	if direction.length() < 1.0:
		return
	
	var unit: Vector2 = direction.normalized()
	var offset: Vector2 = Vector2(unit.x * arrow_radius * arrow_x_multiplier, unit.y * arrow_radius)
	arrow.position = player_screen + offset
	arrow.rotation = direction.angle()
