extends CanvasLayer

signal start_game_signal
signal set_pegs
signal clear_pegs

func set_turn_label(player: String):
	$PlayerLabel.text = player.capitalize() + "'s turn!"
	if player.to_lower() == "red":
		$PlayerLabel.add_theme_color_override("font_color", Color.RED)
	else:
		$PlayerLabel.add_theme_color_override("font_color", Color.DODGER_BLUE)

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerLabel.add_theme_color_override("font_color", Color.RED)
	$PlayerLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_game():
	$game_over.hide()
	start_game_signal.emit()

func game_over(win: bool = false, winner: String = "Nobody"):
	$game_over.set_winner(winner)
	$game_over.show()


func _on_new_game_pressed():
	$StartMenu.hide()
	$PlayerLabel.show()
	print("Showing player label")
	start_game()


func _on_set_pegs_pressed():
	set_pegs.emit()


func _on_clear_pegs_pressed():
	clear_pegs.emit()
