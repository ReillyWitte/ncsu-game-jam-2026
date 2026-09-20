extends CharacterBody2D

enum NPC_STATE {IDLE, WALK}
enum NPC_TYPE {MAN, SNAKE, TURTLE, DEER}

const BLOOD_SCENE = preload("res://Gameplay/NPCs/blood.tscn")

@export var move_speed : float = 60
@export var idle_time : float = randf_range(0.5, 3)
@export var walk_time : float = randf_range(1,6)
@export var rotation_speed: float = 1
var rotation_direction: float = 0

var move_direction : Vector2 = Vector2.ZERO
var current_state : NPC_STATE = NPC_STATE.IDLE
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var physical_collision_shape: CollisionShape2D = $CollisionShape2D
var walk_animation: String
var idle_animation: String
var npc_species: int
var npc_point_value: int

func _ready():
	Global.numNPC = Global.numNPC + 1
	physical_collision_shape.shape = physical_collision_shape.shape.duplicate()
	collision_shape.shape = collision_shape.shape.duplicate()
	npc_species = get_random_npc()
	pick_new_state()

func _physics_process(delta):
	if current_state == NPC_STATE.WALK:
		# Turn the whole body, the same way the player does
		rotation += rotation_direction * rotation_speed * delta
		# Only ever move along the body's forward direction
		velocity = transform.x * move_speed
		move_and_slide()

		
func pick_new_state():
	if(current_state == NPC_STATE.IDLE):
		current_state = NPC_STATE.WALK
		sprite.play(walk_animation)
		rotation_direction = float(randi_range(-1, 1))
		timer.start(walk_time)
	elif(current_state == NPC_STATE.WALK):
		current_state = NPC_STATE.IDLE
		sprite.play(idle_animation)
		velocity = Vector2.ZERO
		# Stop turning while idle
		rotation_direction = 0.0
		timer.start(idle_time)


func _on_timer_timeout():
	pick_new_state()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("player"):
		#print("Gas collected")
		Global.updatePlayerScore(npc_point_value)
		if npc_point_value > 0:
			Global.kill_count = Global.kill_count + 1
		print("Splat")
		print("Your score: ", Global.player_score)
		var new_blood: Node2D = BLOOD_SCENE.instantiate()
		new_blood.position = position
		var y_scale = body.velocity.length()/200
		if y_scale < 0.5:
			y_scale = 0.5
		new_blood.scale = Vector2(1,y_scale)
		new_blood.rotation = body.velocity.angle() + deg_to_rad(90)
		add_sibling(new_blood)
		var tile_map: Node = get_parent().get_node("TileMap")
		get_parent().move_child(new_blood, tile_map.get_index() + 1)
		queue_free()
		
func get_random_npc() -> int:
	var random_value = randf_range(0,100)
	
	if random_value <= 90:
		walk_animation = "walk"
		idle_animation = "idle"
		physical_collision_shape.shape.size = Vector2(20,27)
		collision_shape.shape.size = Vector2(20,27)
		npc_point_value = 100
		return NPC_TYPE.MAN
	elif random_value <= 93.3:
		walk_animation = "snake_walk"
		idle_animation = "snake_idle"
		physical_collision_shape.shape.size = Vector2(30,14)
		collision_shape.shape.size = Vector2(30,14)
		npc_point_value = -100
		return NPC_TYPE.SNAKE
	elif random_value <= 96.6:
		walk_animation = "turtle_walk"
		idle_animation = "turtle_idle"
		physical_collision_shape.shape.size = Vector2(27,16)
		collision_shape.shape.size = Vector2(27,16)
		npc_point_value = -250
		return NPC_TYPE.TURTLE
	elif random_value <= 100:
		walk_animation = "deer_walk"
		idle_animation = "deer_idle"
		physical_collision_shape.shape.size = Vector2(64,18)
		collision_shape.shape.size = Vector2(64,18)
		npc_point_value = -500
		return NPC_TYPE.DEER
	else:
		return 0
