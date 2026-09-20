extends Node

var level = 0

var player_score : int = 0
var kill_count: int = 0
var last_kill_time: int = -10000
var last_multiplier: float = 1
const combo_increment = 0.5
const combo_time_interval = 2000

var maxGas: int = 15
var numGas: int = 0
var maxNPC: int = 480
var numNPC: int = 0
var maxNitrous: int = 10
var numNitrous: int = 0

var player_position: Vector2

const fullGasLevel: int = 100
var currentGasLevel: int = 5

func updatePlayerScore(npc_point_value:int):
	var kill_time = Time.get_ticks_msec()
	var combo_multiplier = get_combo_multiplier(kill_time, last_kill_time, last_multiplier, npc_point_value)
	player_score = player_score + int(npc_point_value * combo_multiplier)
	print("Combo Mult:", combo_multiplier)
	print("Last Kill Time:", last_kill_time)
	print("Current Kill Time:", kill_time)
	last_kill_time = kill_time
	last_multiplier = combo_multiplier
	

func get_combo_multiplier(kill_time: int, prev_kill_time: int, prev_mult: float, point_value: int) -> float:
	if point_value <= 0:
		return 1
	elif kill_time < prev_kill_time + combo_time_interval:
		return prev_mult + combo_increment
	else:
		return 1

func reset_globals():
	player_score = 0
	kill_count= 0
	last_kill_time= -10000
	last_multiplier= 1.0

	maxGas = 15
	numGas = 0
	maxNPC = 480
	numNPC = 0
	maxNitrous = 10
	numNitrous = 0

	currentGasLevel = 100
	
