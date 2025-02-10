extends Node2D

var rows = []
const PEG = preload("res://game_objects/peg/peg.tscn")
const PEGS_LENGTH = 7
const PEG_SPACING = 90
const NUM_PEG_ROWS = 4

func setup_row(length: int, spacing: int, level: int) -> Array:
	var row = []
	var offset_mag = spacing / 2
	var offset = offset_mag if length % 2 == 0 else 0
	for n in length:
		var peg = PEG.instantiate()
		var peg_offset = Vector2(global_position.x + n * spacing + offset, spacing * level)
		peg.global_position = global_position + peg_offset
		row.append(peg)
		add_child(peg)
	return row

func setup_connections(rows: Array):
	for i in len(rows) - 1:
		if i % 2 == 0:
			for j in len(rows[i]):
				if (j < len(rows[i+1])):
					rows[i][j].connections.append(rows[i+1][j])
				if (j > 0):
					rows[i][j].connections.append(rows[i+1][j-1])
		else:
			for j in len(rows[i]):
				if (j < len(rows[i+1])):
					rows[i][j].connections.append(rows[i+1][j+1])
				rows[i][j].connections.append(rows[i+1][j])
		if OS.is_debug_build():
			for j in len(rows[i]):
				for connection in rows[i][j].connections:
						var line2d = Line2D.new()
						line2d.add_point(rows[i][j].position + Vector2(0, 25))
						line2d.add_point(connection.position)
						line2d.width = 5
						line2d.default_color = Color("YELLOW_GREEN")
						add_child(line2d)

func calculate_size(num_pegs: int, num_rows: int, peg_spacing: int) -> Vector2i:
	var width = (num_pegs - 1) * peg_spacing
	var height = (num_rows - 1) * peg_spacing
	return Vector2i(width, height)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in NUM_PEG_ROWS:
		rows.append(setup_row(PEGS_LENGTH - (i % 2), PEG_SPACING, i))
	setup_connections(rows)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var peg_board_size: Vector2i = calculate_size(PEGS_LENGTH, NUM_PEG_ROWS, PEG_SPACING)
	var screen_size = get_viewport().size
	global_position = (screen_size - peg_board_size) / 2
