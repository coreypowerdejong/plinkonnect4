extends Node2D

var row1
var row2
var row3
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
	
# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Vector2(30, 30)
	#row1 = setup_row(7, 40, 0)
	#row2 = setup_row(6, 40, 1)
	#row3 = setup_row(7, 40, 2)
	for i in 4:
		rows.append(setup_row(7 - (i % 2), 60, i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
