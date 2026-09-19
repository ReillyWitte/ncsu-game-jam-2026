extends CharacterBody2D

enum NPC_STATE {IDLE, WALK}
enum NPC_TYPE {MAN, SNAKE, TURTLE, DEER}

@export var move_speed : float = 60
@export var idle_time : float = 5
@export var walk_time : float = 2
@export var rotation_speed: float = 1
var rotation_direction: float = 0

var move_direction : Vector2 = Vector2.ZERO
var current_state : NPC_STATE = NPC_STATE.IDLE
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

func _ready():
	Global.numNPC = Global.numNPC + 1
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
		sprite.play("walk")
		rotation_direction = float(randi_range(-1, 1))
		timer.start(walk_time)
	elif(current_state == NPC_STATE.WALK):
		current_state = NPC_STATE.IDLE
		sprite.play("idle")
		velocity = Vector2.ZERO
		# Stop turning while idle
		rotation_direction = 0.0
		timer.start(idle_time)


func _on_timer_timeout():
	pick_new_state()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		#print("Gas collected")
		Global.player_score = Global.player_score + 100
		Global.kill_count = Global.kill_count + 1
		print("Splat")
		print("Your score: ", Global.player_score)
		queue_free()
		
func get_random_npc() -> int:
	var random_value = randf_range(0,100)
	
	if random_value < 90:
		return NPC_TYPE.MAN
	return 0
