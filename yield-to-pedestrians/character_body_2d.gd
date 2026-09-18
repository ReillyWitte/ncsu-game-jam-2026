extends CharacterBody2D

@export var max_speed = 275
@export var min_speed = 100
var old_passed_time = Time.get_ticks_msec()

@export var speed = max_speed
@export var rotation_speed = 4

var rotation_direction = 0

var maze: Node = null

func _ready() -> void:
	maze = get_tree().get_first_node_in_group("maze")
	

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * Input.get_axis("down", "up") * speed

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
	if passed_time >= old_passed_time + 350:
		Global.currentGasLevel = Global.currentGasLevel - 1
		print(Global.currentGasLevel)
		old_passed_time = passed_time
