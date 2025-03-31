extends Node2D
class_name Board

enum Difficulty {
	EASY = 20,
	MEDIUM = 30,
	HARD = 40,
	EXPERT = 50,
	INSANE = 60
}

var GRID_SIZE: int = 9

var valid_numbers: Array[int] = []

var rows: Array[Array] = []
var cols: Array[Array] = []
var grid: Array = []

var res_grid: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_board()
	generate_grid()
	apply_puzzle(Difficulty.EASY)
	for row in grid:
		print(row)
	print()
	print("RES_GRID")
	print()
	for row in res_grid:
		print(row)

func _process(delta: float) -> void:
	pass

func apply_puzzle(difficulty: Difficulty):
	var total_hides: int = difficulty
	print(total_hides)
	res_grid = grid.duplicate()
	var rnd: RandomNumberGenerator = RandomNumberGenerator.new()
	while total_hides > 0:
		var rnd_col: int = rnd.randi_range(0, GRID_SIZE - 1)
		var rnd_row: int = rnd.randi_range(0, GRID_SIZE - 1)
		# TODO refactor
		while res_grid[rnd_row][rnd_col] == 0:
			rnd_col = rnd.randi_range(0, GRID_SIZE - 1)
			rnd_row = rnd.randi_range(0, GRID_SIZE - 1)
		res_grid[rnd_row][rnd_row] = 0
		total_hides -= 1

func init_board() -> void:
	for row in range(GRID_SIZE):
		grid.append([])
		for col in range(GRID_SIZE):
			grid[row].append(0)
	for i in range(GRID_SIZE):
		valid_numbers.append(i + 1)

func generate_grid() -> void:
	if grid_back_tracking():
		print("GENERATE GRID SUCCESSFUL")

func get_column(col: int) -> Array:
	var col_elems: Array[int] = []
	for row in range(GRID_SIZE):
		col_elems.append(grid[row][col])
	return col_elems

func get_row(row: int) -> Array:
	return grid[row]

func get_box(col: int, row: int) -> Array:
	var box_elems: Array[int] = []
	var start_row = 0
	var start_col = 0
	if col >= 6:
		start_col = 6
	elif col >=3:
		start_col = 3
	if row >= 6:
		start_row = 6
	elif row >= 3:
		start_row = 3
	for offset_row in range(int(sqrt(GRID_SIZE))):
		for offset_col in range(int(sqrt(GRID_SIZE))):
			box_elems.append(grid[start_row + offset_row][start_col + offset_col])
	return box_elems

func grid_back_tracking() -> bool:
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			if grid[row][col] == 0:
				var remain_numbers: Array[int] = valid_numbers
				remain_numbers.shuffle()
				for number in remain_numbers:
					if is_valid(col, row, number):
						grid[row][col] = number
						if grid_back_tracking():
							return true
						grid[row][col] = 0
				return false
	return true

func is_valid(col: int, row: int, num: int) -> bool:
	return is_valid_column(col, num) and is_valid_row(row, num) and is_valid_box(col, row, num)

func is_valid_column(col: int, num: int) -> bool:
	return num not in get_column(col)

func is_valid_row(row: int, num: int) -> bool:
	return num not in get_row(row)

func is_valid_box(col: int, row: int, num: int) -> bool:
	return num not in get_box(col, row)
