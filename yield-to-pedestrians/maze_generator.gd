extends Node2D

const N = 0x1 # 1  (North)
const E = 0x2 # 2  (East)
const S = 0x4 # 4  (South)
const W = 0x8 # 8  (West)

# Direction vectors mapped to bitwise values
var cell_walls = {
	Vector2i(0, -1): N,
	Vector2i(1, 0): E,
	Vector2i(0, 1): S,
	Vector2i(-1, 0): W
}

@export var grid_width: int = 33
@export var grid_height: int = 18

# Chance to carve extra connections between adjacent roads (0.0 to 1.0)
@export_range(0.0, 1.0) var extra_connection_chance: float = 0.10 

@onready var map: TileMap = $TileMap

var grid: Dictionary = {}

# Map each 0-15 bitwise ID to your asset's atlas coordinates Vector2i(x, y)
var tile_coords = {
	0: Vector2i(0, 0),    # Empty/Solid background block
	1: Vector2i(6, 11),   # North dead-end
	2: Vector2i(0, 6),    # East dead-end
	3: Vector2i(8, 5),    # North + East corner
	4: Vector2i(6, 0),    # South dead-end
	5: Vector2i(6, 5),    # North + South straight vertical line
	6: Vector2i(8, 4),    # East + South corner
	7: Vector2i(8, 9),    # North + East + South T-junction
	8: Vector2i(11, 6),   # West dead-end
	9: Vector2i(9, 5),    # North + West corner
	10: Vector2i(5, 6),   # East + West straight horizontal line
	11: Vector2i(11, 9),  # North + East + West T-junction
	12: Vector2i(9, 4),   # South + West corner
	13: Vector2i(6, 8),   # North + South + West T-junction
	14: Vector2i(3, 6),   # East + South + West T-junction
	15: Vector2i(6, 6)    # 4-way intersection
}

func _ready() -> void:
	randomize()
	generate_maze()

func generate_maze() -> void:
	map.clear()
	grid.clear()
	
	# 1. Fill entire grid with 0 (Grass / Wall)
	for x in range(grid_width):
		for y in range(grid_height):
			grid[Vector2i(x, y)] = 0

	# 2. Carve initial paths starting at (0, 0)
	carve_passages_from(Vector2i(0, 0))
	
	# 3. Punch extra openings between adjacent paths for loops and intersections
	add_extra_connections()
	
	# 4. Draw the maze
	draw_maze()

func carve_passages_from(current: Vector2i) -> void:
	var directions = cell_walls.keys()
	directions.shuffle()
	
	for offset in directions:
		# Jump 3 steps ahead to leave a 2-tile grass gap
		var neighbor = current + (offset * 3)
		var gap_1 = current + offset
		var gap_2 = current + (offset * 2)
		
		if is_in_bounds(neighbor) and grid[neighbor] == 0:
			var direction_bit = cell_walls[offset]
			var opposite_bit = cell_walls[-offset]
			
			# Carve path across current cell, both gap cells, and the neighbor cell
			grid[current] |= direction_bit
			grid[gap_1] = direction_bit | opposite_bit
			grid[gap_2] = direction_bit | opposite_bit
			grid[neighbor] |= opposite_bit
			
			carve_passages_from(neighbor)

func add_extra_connections() -> void:
	# Iterate through the grid stepping by 3 to match the generation nodes
	for x in range(0, grid_width, 3):
		for y in range(0, grid_height, 3):
			var current = Vector2i(x, y)
			
			if grid[current] == 0:
				continue
				
			for offset in cell_walls.keys():
				var neighbor = current + (offset * 3)
				var gap_1 = current + offset
				var gap_2 = current + (offset * 2)
				
				# If an adjacent neighbor exists and has a road
				if is_in_bounds(neighbor) and grid[neighbor] != 0:
					var direction_bit = cell_walls[offset]
					var opposite_bit = cell_walls[-offset]
					
					# If there isn't already a path connecting them
					if (grid[current] & direction_bit) == 0:
						if randf() < extra_connection_chance:
							grid[current] |= direction_bit
							grid[gap_1] = direction_bit | opposite_bit
							grid[gap_2] = direction_bit | opposite_bit
							grid[neighbor] |= opposite_bit

func is_in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < grid_width and cell.y >= 0 and cell.y < grid_height

func draw_maze() -> void:
	var source_id = map.tile_set.get_source_id(0)
	
	for cell in grid.keys():
		var tile_id = grid[cell]
		
		if tile_coords.has(tile_id):
			var atlas_coords = tile_coords[tile_id]
			map.set_cell(0, cell, source_id, atlas_coords)
