extends Node2D

signal turn_change(turn: bool)
signal board_full

const TOKEN_SLOT = preload("res://game_objects/token_slot/token_slot.tscn")
const TOKEN = preload("res://game_objects/token/token.tscn")
const TOKEN_SPACING = 90
const BOARD_WIDTH = 7
const BOARD_HEIGHT = 6
var board_pixel_height: int
var board = []
var full_columns = []
var turn: bool = false:
	set(value):
		turn_change.emit(value)
		turn = value


func setup_board(width: int) -> Array:
	full_columns = []
	board = []
	for i in width:
		board.append([])
		full_columns.append(false)
	return board

func add_token(token_position: int, type: int, height: int) -> bool:
	# return true on successful token add
	# return false if column is full

	# if column is available
	if not len(board[token_position]) == height:
		board[token_position].append(type)
		
		# check if full after adding token
		if len(board[token_position]) == height:
			full_columns[token_position] = true
		
		# return successfully added token
		return true
	
	# no early return, token not added - already full column
	return false

func create_token(slot: int):
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
	var success = add_token(slot_id, 0, BOARD_HEIGHT)
	if success:
		create_token(slot_id)
	
	# early return if board not full
	for column in full_columns:
		if column == false:
			return
	# if made it here, board is full
	board_full.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	board = setup_board(BOARD_WIDTH)
	board_pixel_height = BOARD_HEIGHT * TOKEN_SPACING
	$TokenGrid.global_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
