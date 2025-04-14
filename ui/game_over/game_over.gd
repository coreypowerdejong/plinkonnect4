extends Control

signal new_game_pressed(all_pegs: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_new_game_pressed():
	var all_pegs_toggle = $VBoxContainer/AllPegs.is_pressed()
	new_game_pressed.emit(all_pegs_toggle)

func set_winner(winner: String = "Unknown"):
	$VBoxContainer/WinnerLabel.text = winner + " wins!"
