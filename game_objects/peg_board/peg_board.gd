extends Node2D

var rows = []
var slots = []
var fall_path = []
var fall_line = Line2D.new()
const PEG = preload("res://game_objects/peg/peg.tscn")
const TOKEN_SLOT = preload("res://game_objects/token_slot/token_slot.tscn")
const PEGS_LENGTH = 7
const PEG_SPACING = 90
const NUM_PEG_ROWS = 5

signal token_inserted(slot_id: int)

func setup_row(length: int, spacing: int, level: int, locked: bool = false, secret: bool = false) -> Array:
	var row = []
	@warning_ignore("integer_division")
	var offset_mag: int = spacing / 2
	var offset = offset_mag if length % 2 == 0 else 0
	for n in length:
		var peg = PEG.instantiate()
		var peg_offset = Vector2(global_position.x + n * spacing + offset, spacing * level)
		peg.global_position = global_position + peg_offset
		row.append(peg)
		peg.peg_toggled.connect(_on_peg_toggled)
		peg.locked = locked
		peg.idx = n
		peg.secret = secret
		add_child(peg)
	return row

func find_peg_below(rows_arr: Array, i: int, j: int):
	var lookahead = 0
	while not rows_arr[i+1+lookahead][j].enabled:
		lookahead += 2
	return rows_arr[i+1+lookahead][j]
	
func setup_connections(rows_arr: Array):
	for i in len(rows_arr) - 1:
		if i % 2 == 0:
			for j in len(rows_arr[i]):
				rows_arr[i][j].connections = []
				if not rows_arr[i][j].enabled:
					continue
				if (j < len(rows_arr[i+1])):
					var next_peg = find_peg_below(rows_arr, i, j)
					rows_arr[i][j].connections.append(next_peg)
				if (j > 0):
					var next_peg = find_peg_below(rows_arr, i, j-1)
					rows_arr[i][j].connections.append(next_peg)
		else:
			for j in len(rows_arr[i]):
				rows_arr[i][j].connections = []
				if not rows_arr[i][j].enabled:
					continue
				if (j < len(rows_arr[i+1])):
					var next_peg = find_peg_below(rows_arr, i, j+1)
					rows_arr[i][j].connections.append(next_peg)
				var next_peg = find_peg_below(rows_arr, i, j)
				rows_arr[i][j].connections.append(next_peg)
		if OS.is_debug_build():
			for j in len(rows_arr[i]):
				for connection in rows_arr[i][j].connections:
					var line2d = Line2D.new()
					line2d.add_point(rows_arr[i][j].position + Vector2(0, 25))
					line2d.add_point(connection.position)
					line2d.width = 5
					if connection.secret:
						line2d.default_color = Color("DIM_GRAY")
					else:
						line2d.default_color = Color("YELLOW_GREEN")
					line2d.add_to_group("debug_lines")
					add_child(line2d)

func calculate_size(num_pegs: int, num_rows: int, peg_spacing: int) -> Vector2:
	var width = (num_pegs - 1) * peg_spacing
	var height = (num_rows - 1) * peg_spacing
	return Vector2(width, height)

func get_size() -> Vector2:
	return calculate_size(PEGS_LENGTH, NUM_PEG_ROWS, PEG_SPACING)

func create_token_slots(num_slots: int, slot_spacing: int) -> Array:
	var slots = []
	for n in num_slots:
		var slot = TOKEN_SLOT.instantiate()
		slot.global_position = Vector2(global_position.x + n * slot_spacing, global_position.y - 30)
		slot.id = n
		slot.activated.connect(_on_token_inserted)
		slots.append(slot)
		add_child(slot)
	return slots


func _on_peg_toggled(state: bool):
	for child in get_children():
		if child is Line2D:
			child.queue_free()
	setup_connections(rows)

func _on_token_inserted(slot_id: int) -> int:
	for peg in fall_path:
		peg.set_color()
	fall_path = []
	# find_peg_below starts at row -1 to work on even rows
	var current_peg = find_peg_below(rows, -1, slot_id)
	while current_peg.connections:
		fall_path.append(current_peg)
		current_peg = current_peg.connections.pick_random()
	fall_path.append(current_peg)
	for peg in fall_path:
		peg.set_color(Color("CRIMSON"))
	
	if OS.is_debug_build():
		if is_instance_valid(fall_line):
			fall_line.queue_free()
		fall_line = Line2D.new()
		for peg in fall_path:
			fall_line.add_point(peg.position)
			fall_line.width = 5
			fall_line.default_color = Color("ORANGE")
			add_child(fall_line)
	
	token_inserted.emit(fall_path[-1].idx)
	return fall_path[-1].idx

# Called when the node enters the scene tree for the first time.
func _ready():
	var locked = false
	var secret = false
	for i in NUM_PEG_ROWS:
		if i == NUM_PEG_ROWS - 2:
			locked = true
		if i == NUM_PEG_ROWS - 1:
			secret = true
		else:
			secret = false
		rows.append(setup_row(PEGS_LENGTH - (i % 2), PEG_SPACING, i, locked, secret))
	setup_connections(rows)
	slots = create_token_slots(PEGS_LENGTH, PEG_SPACING)
	
	# screen resize signal
	get_tree().get_root().size_changed.connect(_resize)

func _resize():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#var peg_board_size: Vector2 = calculate_size(PEGS_LENGTH, NUM_PEG_ROWS, PEG_SPACING)
	pass
