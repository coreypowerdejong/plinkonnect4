extends Control

signal start_game(all_pegs: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_pressed():
	var all_pegs_toggle = $VBoxContainer/AllPegs.is_pressed()
	start_game.emit(all_pegs_toggle)
