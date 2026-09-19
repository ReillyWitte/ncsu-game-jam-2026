extends CharacterBody2D

@export var fuel_loss_time = 350
@export var max_speed = 450
var old_max_speed = max_speed
@export var min_speed = 275
var old_min_speed = min_speed
var old_passed_time = Time.get_ticks_msec()
var nitro_grab_time = 0

@export var speed = max_speed
@export var rotation_speed = 3.75
@export var grip: float = 20
@export var drift_grip: float = 1
@export var drift_turn_boost: float = 1.2

# Camera stuff
@export var camera_turn_speed: float = 3.25
@export var camera_min_speed: float = 20
@onready var camera: Camera2D = $Camera2D
@export var camera_offset_angle: float = PI / 2.0
@export var camera_max_lean: float = 0.6
@export_range(0.0, 1.0) var camera_drift_follow: float = 0.4

var rotation_direction = 0

var maze: Node = null

func _ready() -> void:
	maze = get_tree().get_first_node_in_group("maze")
	

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	var target_velocity = transform.x * Input.get_axis("down", "up") * speed
	var current_grip = grip
	if Input.is_action_pressed("drift"):
		current_grip = drift_grip
		rotation_direction *= drift_turn_boost
		
	velocity = velocity.lerp(target_velocity, clampf(current_grip * get_physics_process_delta_time(), 0.0, 1.0))

func speed_boost() -> void:
	nitro_grab_time = Time.get_ticks_msec()
	max_speed = 800
	min_speed = 750
	speed = max_speed

func update_camera(delta: float) -> void:
	# Default target is the car's facing; this also eases the camera back when slow, instead of freezing
	var target_angle: float = rotation
	
	if velocity.length() >= camera_min_speed:
		var travel_angle: float = velocity.angle()
		# When reversing, flip the angle so the view doesn't spin 180 degrees
		if velocity.dot(transform.x) < 0.0:
			travel_angle += PI
		# Signed angle between facing and travel, i.e. how far the car is sliding
		var slide: float = angle_difference(rotation, travel_angle)
		# Lean toward the travel direction by a fraction, capped so it never swings far
		target_angle = rotation + clampf(slide * camera_drift_follow, -camera_max_lean, camera_max_lean)
	
	# Quarter turn so travel direction is screen-up
	target_angle += camera_offset_angle
	# lerp_angle takes the shortest way around the circle
	camera.global_rotation = lerp_angle(camera.global_rotation, target_angle, clampf(camera_turn_speed * delta, 0.0, 1.0))

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	update_camera(delta)
	# Temp
	if maze != null:
		#print("On grass: ", maze.is_grass_at(global_position))
		if maze.is_grass_at(global_position) == true:
			if speed > min_speed:
				speed = speed - 5
		else:
			if speed < max_speed:
				speed = speed + 5
	var passed_time = Time.get_ticks_msec()
	if passed_time >= old_passed_time + fuel_loss_time:
		Global.currentGasLevel = Global.currentGasLevel - 1
		print(Global.currentGasLevel)
		old_passed_time = passed_time
	if passed_time >= nitro_grab_time + 3000 and nitro_grab_time != 0:
		max_speed = old_max_speed
		min_speed = old_min_speed
		speed = max_speed
		nitro_grab_time = 0
	Global.player_position = global_position
	#print(velocity.length())
