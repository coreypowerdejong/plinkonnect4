extends Node2D

const GRID_CELL = preload("res://game_objects/grid_cell.png")
const TOKEN_SPACING = 90
const BOARD_WIDTH = 7
const BOARD_HEIGHT = 6

var board_pixel_height: int

func calculate_size(num_slots: int, num_rows: int, token_spacing: int) -> Vector2:
	var width = (num_slots - 1) * token_spacing
	var height = (num_rows - 1) * token_spacing
	return Vector2(width, height)

func generate_grid(width: int, height: int, spacing: int):
	for i in width:
		for j in height:
			var sprite = Sprite2D.new()
			sprite.texture = GRID_CELL
			sprite.position = Vector2(i*TOKEN_SPACING, board_pixel_height - (j+1)*TOKEN_SPACING)
			add_child(sprite)


# Called when the node enters the scene tree for the first time.
func _ready():
	board_pixel_height = calculate_size(BOARD_WIDTH, BOARD_HEIGHT, TOKEN_SPACING).y
	generate_grid(BOARD_WIDTH, BOARD_HEIGHT, TOKEN_SPACING)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
