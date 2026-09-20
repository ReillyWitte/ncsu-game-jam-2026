extends CharacterBody2D

# Textures
@onready var player_sprite: Sprite2D = $Sprite2D
const DEER_STRAIGHT: Texture2D = preload("res://Assets/deer_glasses.png")
const DEER_LTURN: Texture2D = preload("res://Assets/deer_lturn.png")
const DEER_RTURN: Texture2D = preload("res://Assets/deer_rturn.png")


var old_passed_time = Time.get_ticks_msec()
var nitro_grab_time = 0

var minInt: float = 7.5
var maxInt: float = 15.0


# Movement constants
@export var rotation_speed := 3.75
@export var min_speed = 150
@export var fuel_loss_time = 350
@export var max_speed = 450
@export var grass_decel = 10
@export var nitro_speed := 1000.0
@export var nitro_rotation_speed := 2.0
@export var grip := 20.0
@export var drift_grip := 1.0
@export var drift_turn_boost := 1.2

var speed = max_speed
var old_max_speed = max_speed
var old_min_speed = min_speed

# Camera stuff
@export var camera_turn_speed: float = 3.25
@export var camera_min_speed: float = 20
@onready var camera: Camera2D = $Camera2D
@export var camera_offset_angle: float = PI / 2.0
@export var camera_max_lean: float = 0.6
@export_range(0.0, 1.0) var camera_drift_follow: float = 0.4

# Particles
@onready var drift_particles: CPUParticles2D = $DriftParticles
@onready var nitro_particles: CPUParticles2D = $NitroParticles

# Nitro
@onready var nitro_timer: Timer = $"Nitro Timer"

var rotation_direction = 0

var maze: Node = null

func _ready() -> void:
	maze = get_tree().get_first_node_in_group("maze")
	play_Deer_VoiceLine()
	staggerVoiceLines()

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	
	# Determine speed
	var target_velocity : Vector2
	if !nitro_timer.is_stopped():
		target_velocity = transform.x * nitro_speed
	else:
		target_velocity = transform.x * Input.get_axis("down", "up") * speed
		
	var current_grip = grip
	if rotation_direction < 0:
		player_sprite.texture = DEER_LTURN
	elif rotation_direction > 0:
		player_sprite.texture = DEER_RTURN
	else:
		player_sprite.texture = DEER_STRAIGHT
	if Input.is_action_pressed("drift"):
		current_grip = drift_grip
		rotation_direction *= drift_turn_boost
		drift_particles.emitting = true
	else:
		drift_particles.emitting = false
	if !Input.is_action_pressed("up"):
		current_grip = 5
	

	velocity = velocity.lerp(target_velocity, clampf(current_grip * get_physics_process_delta_time(), 0.0, 1.0))

# Nitro speed boost begin
func speed_boost() -> void:
	nitro_timer.start()
	nitro_particles.emitting = true
	

# Nitro speed boost end
func end_speed_boost() -> void:
	nitro_particles.emitting = false

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
				speed = speed - grass_decel
		else:
			if speed < max_speed:
				speed = speed + grass_decel
	var passed_time = Time.get_ticks_msec()
	if passed_time >= old_passed_time + fuel_loss_time:
		Global.currentGasLevel = Global.currentGasLevel - 1
		old_passed_time = passed_time
	
	
	Global.player_position = global_position
	

func staggerVoiceLines():
	await get_tree().create_timer(8.0).timeout
	play_Person_VoiceLine()


func play_Person_VoiceLine():
	
	#pick random sound 
	Sfx.play_sfx(Sfx.SFX_Person_VoiceLines.pick_random())
	
	#create random interval
	var randomInt = randf_range(minInt, maxInt)
	#apply
	await get_tree().create_timer(randomInt).timeout
	
	# resart
	play_Person_VoiceLine()


func play_Deer_VoiceLine():
	
	#pick random sound 
	Sfx.play_sfx(Sfx.SFX_Deer_VoiceLines.pick_random())
	
	#create random interval
	var randomInt = randf_range(minInt, maxInt)
	#apply
	await get_tree().create_timer(randomInt).timeout
	
	# resart
	play_Deer_VoiceLine()
