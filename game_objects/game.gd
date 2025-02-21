extends Node2D

var active_player: bool = false
@onready var UI = $UI

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = Vector2(get_viewport().size)
	var peg_board_size = $peg_board.get_size()
	var token_board_size = $TokenBoard.get_size()
	$peg_board.global_position = (screen_size - peg_board_size) / 2 + Vector2(0, -300)
	$TokenBoard.global_position = $peg_board.global_position + Vector2(0, token_board_size.y + 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_peg_board_token_inserted(slot_id):
	$TokenBoard.insert_token(slot_id)


func _on_turn_change(turn):
	active_player = turn
	var player_str = "Blue" if active_player else "Red"
	UI.set_turn_label(player_str)


func _on_board_full():
	print("Board full!")
