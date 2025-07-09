extends GridContainer
class_name Board

@export var cell: PackedScene

signal select_cell(col: int, row: int)

enum Difficulty {
	EASY = 1,
	MEDIUM = 45,
	HARD = 50,
	EXPERT = 55,
	MASTER = 60,
	INSANE = 65
}

const GRID_SIZE: int = 9
var CELL_SIZE_WITH_SPACING: int = 35

var valid_numbers: Array[int] = []

var grid: Array = [] # the playground grid
var res_grid: Array = [] # the result grid
var current_col: int = -1
var current_row: int = -1

var window_size = DisplayServer.window_get_size()

func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed && (key_event.keycode in [KEY_UP, KEY_DOWN, KEY_RIGHT, KEY_LEFT]):
			if current_col == -1 || current_row == -1:
				current_col = 0
				current_row = 0
			else:
				if key_event.keycode == KEY_UP:
					current_row -= 1
				if key_event.keycode == KEY_DOWN:
					current_row += 1
				if key_event.keycode == KEY_RIGHT:
					current_col += 1
				if key_event.keycode == KEY_LEFT:
					current_col -= 1
			emit_signal("select_cell", current_col, current_row)

func start_game() -> void:
	self.columns = 9
	init_board()
	generate_grid()
	apply_puzzle(Difficulty.EASY)
	#cell.connect("change_value", check_winner)

func apply_puzzle(difficulty: Difficulty):
	var total_hides: int = difficulty
	res_grid = grid.duplicate(true)
	var rnd: RandomNumberGenerator = RandomNumberGenerator.new()
	while total_hides > 0:
		var rnd_col: int = rnd.randi_range(0, GRID_SIZE - 1)
		var rnd_row: int = rnd.randi_range(0, GRID_SIZE - 1)
		# TODO refactor
		var hidden_tile: Tile = get_grid_tile(rnd_row, rnd_col)
		while hidden_tile.current_value == 0:
			print("in loop", rnd_col, rnd_row)
			rnd_col = rnd.randi_range(0, GRID_SIZE - 1)
			rnd_row = rnd.randi_range(0, GRID_SIZE - 1)
			hidden_tile = get_grid_tile(rnd_row, rnd_col)
		hidden_tile.current_value = 0
		hidden_tile.fixed = false
		total_hides -= 1

func init_board() -> void:
	for row in range(GRID_SIZE):
		grid.append([])
		valid_numbers.append(row + 1)
		for col in range(GRID_SIZE):
			var new_button: Tile = cell.instantiate()
			new_button.custom_minimum_size = Vector2(30, 30)
			new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			new_button.size_flags_vertical = Control.SIZE_EXPAND_FILL

			
			#var init_pos: Vector2
			#init_pos.x = (window_size.x - GRID_SIZE * CELL_SIZE_WITH_SPACING) / 2
			#init_pos.y = (window_size.y - GRID_SIZE * CELL_SIZE_WITH_SPACING) / 2
			
			#new_button.position = init_pos + Vector2(col * CELL_SIZE_WITH_SPACING, row * CELL_SIZE_WITH_SPACING)
			new_button.position = Vector2(col * CELL_SIZE_WITH_SPACING, row * CELL_SIZE_WITH_SPACING)
			
			#new_button.correct_value = res_grid[row][col]
			new_button.col = col
			new_button.row = row
			#if grid[row][col] != 0:
				#new_button.text = str(grid[row][col])
			add_child(new_button)
			grid[row].append(new_button)
			print(new_button.position)

func generate_grid() -> void:
	if grid_back_tracking():
		print("GENERATE GRID SUCCESSFUL")

func get_column(col: int) -> Array:
	var col_elems: Array[int] = []
	for row in range(GRID_SIZE):
		col_elems.append(get_grid_tile(row, col).correct_value)
	return col_elems

func get_row(row: int) -> Array:
	var row_elems: Array[int] = []
	for col in range(GRID_SIZE):
		row_elems.append(get_grid_tile(row, col).correct_value)
	return row_elems

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
			box_elems.append(grid[start_row + offset_row][start_col + offset_col].correct_value)
	return box_elems

func get_grid_tile(row: int, col: int) -> Tile:
	return grid[row][col] as Tile

func grid_back_tracking() -> bool:
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			var current_tile = get_grid_tile(row, col)
			if current_tile.correct_value == 0:
				var remain_numbers: Array[int] = valid_numbers
				remain_numbers.shuffle()
				for number in remain_numbers:
					if is_valid(col, row, number):
						current_tile.correct_value = number
						current_tile.current_value = number
						current_tile.text = str(number)
						if grid_back_tracking():
							return true
						current_tile.correct_value = 0
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

func check_winner() -> bool:
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			if grid[row][col] != res_grid[row][col]:
				print("ALMOST")
				return false
	print("VICTORY")
	return true
