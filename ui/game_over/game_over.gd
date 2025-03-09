extends Control

signal new_game_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_new_game_pressed():
	new_game_pressed.emit()

func set_winner(winner: String = "Unknown"):
	$VBoxContainer/WinnerLabel.text = winner + " wins!"
