extends Node2D

var rows = []
const PEG = preload("res://game_objects/peg/peg.tscn")

func setup_row(length: int, spacing: int, level: int) -> Array:
	var row = []
	var offset_mag = spacing / 2
	var offset = offset_mag if length % 2 == 0 else 0
	for n in length:
		var peg = PEG.instantiate()
		var peg_offset = Vector2(global_position.x + n * spacing + offset, spacing * level)
		peg.global_position = global_position + peg_offset
		print("Creating peg at " + str(peg.global_position))
		row.append(peg)
		add_child(peg)
	return row

func setup_connections(rows: Array):
	var edges = []
	for row in rows:
		pass
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Vector2(30, 30)
	for i in 4:
		rows.append(setup_row(7 - (i % 2), 60, i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
