extends Node2D

signal turn_change(turn: bool)
signal board_full
signal win_detected(victor: bool)

const TOKEN_SLOT = preload("res://game_objects/token_slot/token_slot.tscn")
const TOKEN = preload("res://game_objects/token/token.tscn")
const TOKEN_SPACING = 90
const BOARD_WIDTH = 7
const BOARD_HEIGHT = 6
var board_pixel_height: int
var board = []
var column_counts = []
var full_columns = []
var turn: bool = false:
	set(value):
		turn_change.emit(value)
		turn = value


func setup_board() -> Array:
	full_columns = []
	full_columns.resize(BOARD_WIDTH)
	full_columns.fill(false)
	board = []
	for i in BOARD_WIDTH:
		var temp = []
		temp.resize(BOARD_HEIGHT)
		temp.fill(null)
		board.append(temp)
	column_counts = []
	column_counts.resize(BOARD_WIDTH)
	column_counts.fill(0)
	return board

func add_token(token_position: int, type: int, height: int) -> bool:
	# return true on successful token add
	# return false if column is full

	# if column is available
	var column_height = column_counts[token_position]
	if column_height != height:
		board[token_position][column_height] = type
		column_counts[token_position] += 1
		# check if full after adding token
		if column_counts[token_position] == height:
			full_columns[token_position] = true
		
		# return successfully added token
		return true
	
	# no early return, token not added - already full column
	return false

func create_token(slot: int):
	var t = TOKEN.instantiate()
	var j = column_counts[slot]
	t.position = Vector2(slot*TOKEN_SPACING, board_pixel_height - (j+1)*TOKEN_SPACING)
	if turn:
		t.type = 1
	else:
		t.type = 0
	add_child(t)
	t.add_to_group("tokens")

func calculate_size(num_slots: int, num_rows: int, token_spacing: int) -> Vector2:
	var width = (num_slots - 1) * token_spacing
	var height = (num_rows - 1) * token_spacing
	return Vector2(width, height)

func get_size():
	return calculate_size(BOARD_WIDTH, BOARD_HEIGHT, TOKEN_SPACING)

func reset_tokens():
	setup_board()
	get_tree().call_group("tokens", "queue_free")

func get_subsection_from_centre(centre: Vector2, radius: int):
	var x1 = max(centre.x - radius, 0)
	var x2 = min(centre.x + radius, BOARD_WIDTH)
	var narrow_board = board.slice(x1, x2 + 1)
	return narrow_board
	

func all_values_match(values: Array, expected) -> bool:
	if values.any(func(value): return value == null):
		return false
	return values.all(func(value): return value == expected)
	
func check_win(sub_board: Array) -> bool:
	# slide 4 possible windows across to check for win ( | - \ / )

	# vertical window
	for i in range(len(sub_board)):
		for j in range(BOARD_HEIGHT - 3):
			var current = sub_board[i][j]
			var line = [
				sub_board[i][j],
				sub_board[i][j+1],
				sub_board[i][j+2],
				sub_board[i][j+3]
				]
			if all_values_match(line, current):
				return true
	# horizontal window
	for i in range(len(sub_board) - 3):
		for j in range(BOARD_HEIGHT):
			var current = sub_board[i][j]
			var line = [
				sub_board[i][j],
				sub_board[i+1][j],
				sub_board[i+2][j],
				sub_board[i+3][j]
				]
			if all_values_match(line, current):
				return true
	# diagonal up window
	for i in range(3, len(sub_board)):
		for j in range(BOARD_HEIGHT - 3):
			var current = sub_board[i][j]
			var line = [
				sub_board[i][j],
				sub_board[i-1][j+1],
				sub_board[i-2][j+2],
				sub_board[i-3][j+3]
				]
			if all_values_match(line, current):
				return true
	# diagonal down window
	for i in range(3, len(sub_board)):
		for j in range(3, BOARD_HEIGHT):
			var current = sub_board[i][j]
			var line = [
				sub_board[i][j],
				sub_board[i-1][j-1],
				sub_board[i-2][j-2],
				sub_board[i-3][j-3]
				]
			if all_values_match(line, current):
				return true
	return false
	
func insert_token(slot_id):
	var success = add_token(slot_id, int(turn), BOARD_HEIGHT)
	if success:
		create_token(slot_id)
		var token_position = Vector2(slot_id, column_counts[slot_id])
		var small_board = get_subsection_from_centre(token_position, 3)
		var win = check_win(small_board)
		if win:
			win_detected.emit(turn)
			return
	turn = !turn
	# early return if board not full
	for column in full_columns:
		if column == false:
			return
	# if made it here, board is full
	board_full.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	board = setup_board()
	board_pixel_height = BOARD_HEIGHT * TOKEN_SPACING
	$TokenGrid.global_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
