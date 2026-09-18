extends CharacterBody2D

@export var fuel_loss_time = 350
@export var max_speed = 375
var old_max_speed = max_speed
@export var min_speed = 200
var old_min_speed = min_speed
var old_passed_time = Time.get_ticks_msec()
var nitro_grab_time = 0

@export var speed = max_speed
@export var rotation_speed = 4.5

var rotation_direction = 0

var maze: Node = null

func _ready() -> void:
	maze = get_tree().get_first_node_in_group("maze")
	

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * Input.get_axis("down", "up") * speed

func speed_boost() -> void:
	nitro_grab_time = Time.get_ticks_msec()
	max_speed = 800
	min_speed = 750
	speed = max_speed
	

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
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
	print(speed)
