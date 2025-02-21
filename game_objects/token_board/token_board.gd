extends Node2D

signal turn_change(turn: bool)

const TOKEN_SLOT = preload("res://game_objects/token_slot/token_slot.tscn")
const TOKEN = preload("res://game_objects/token/token.tscn")
const TOKEN_SPACING = 90
const BOARD_WIDTH = 7
const BOARD_HEIGHT = 6
var board_pixel_height: int
var board = []
var turn: bool = false:
	set(value):
		turn_change.emit(value)
		turn = value


func setup_board(width: int, height: int) -> Array:
	var board = []
	for i in width:
		board.append([])
	return board

func add_token(board: Array, position: int, type: int, height: int, width: int) -> int:
	var modified_position: int = position
	# if column is full
	if len(board[position]) == height:
		var cursor = position
		var options = []
		var side_valid = true
		# scan for open column on right side
		if position != width - 1:
			while len(board[cursor]) == height:
				cursor += 1
				if cursor == width:
					side_valid = false
			if side_valid:
				options.append(cursor)
		cursor = position
		side_valid = true
		# scan for open column on left side
		if position != 0:
			while len(board[cursor]) == height:
				cursor -= 1
				if cursor < 0:
					side_valid = false
			if side_valid:
				options.append(cursor)
		modified_position = options.pick_random()
	
	board[modified_position].append(type)
	return modified_position

func create_token(board, slot: int):
	var t = TOKEN.instantiate()
	var j = len(board[slot])
	t.position = Vector2(slot*TOKEN_SPACING, board_pixel_height - (j+1)*TOKEN_SPACING)
	if turn:
		t.type = 1
	else:
		t.type = 0
	turn = !turn
	add_child(t)

func calculate_size(num_slots: int, num_rows: int, token_spacing: int) -> Vector2:
	var width = (num_slots - 1) * token_spacing
	var height = (num_rows - 1) * token_spacing
	return Vector2(width, height)

func get_size():
	return calculate_size(BOARD_WIDTH, BOARD_HEIGHT, TOKEN_SPACING)

func insert_token(slot_id):
	var final_slot = add_token(board, slot_id, 0, BOARD_HEIGHT, BOARD_WIDTH)
	create_token(board, final_slot)

# Called when the node enters the scene tree for the first time.
func _ready():
	board = setup_board(BOARD_WIDTH, BOARD_HEIGHT)
	board_pixel_height = BOARD_HEIGHT * TOKEN_SPACING
	$TokenGrid.global_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
