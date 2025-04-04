extends Node2D

var player_str: String
var active_player: bool = false:
	set(value):
		player_str = "Blue" if value else "Red"
var current_slot: int
var locked: bool = false

@onready var UI = $UI

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = Vector2(get_viewport().size)
	var peg_board_size = $peg_board.get_size()
	var token_board_size = $TokenBoard.get_size()
	$peg_board.global_position = (screen_size - peg_board_size) / 2 + Vector2(0, -300)
	$TokenBoard.global_position = $peg_board.global_position + Vector2(0, token_board_size.y + 100)
	UI.start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_peg_board_token_inserted(slot_id):
	current_slot = slot_id
	locked = true
	$peg_board.lock_slots()

func _on_peg_board_token_landed():
	$TokenBoard.insert_token(current_slot)
	
func _on_peg_board_token_finished():
	locked = false
	$peg_board.unlock_slots()

func _on_turn_change(turn):
	active_player = turn
	UI.set_turn_label(player_str)
	$peg_board.set_turn(turn)
	$peg_board.unlock_slots()


func _on_board_full():
	UI.game_over()

func _on_win_detected(victor):
	$UI.game_over(true, player_str)


func _on_ui_start_game():
	$peg_board.reset_pegs()
	$TokenBoard.reset_tokens()
	locked = false
	pass # Replace with function body.


func _on_ui_clear_pegs():
	$peg_board.clear_pegs()


func _on_ui_set_pegs():
	$peg_board.reset_pegs()


func _on_peg_board_slot_mouse_entered(id):
	var total = $FallDistribution.count_paths(
		$peg_board.find_peg_below($peg_board.rows, -1, id))

	var endpoints = $FallDistribution.get_endpoints()
	for p in endpoints:
		$peg_board.fall_dist_labels[p].set_percentage(endpoints[p], total)
		


func _on_peg_board_slot_mouse_exited(id):
	$FallDistribution.clear_endpoints()
	for p in $peg_board.fall_dist_labels:
		p.hide()
