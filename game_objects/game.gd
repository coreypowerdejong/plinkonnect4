extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_viewport().size
	var peg_board_size = $peg_board.get_size()
	var token_board_size = $TokenBoard.get_size()
	$peg_board.global_position = (screen_size - peg_board_size) / 2 + Vector2i(0, -100)
	$TokenBoard.global_position = (screen_size - token_board_size) / 2 + Vector2i(0, 130)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_peg_board_token_inserted(slot_id):
	$TokenBoard.insert_token(slot_id)
