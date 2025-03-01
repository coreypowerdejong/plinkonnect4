extends CanvasLayer

signal start_game_signal

func set_turn_label(player: String):
	$PlayerLabel.text = player.capitalize() + "'s turn!"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_game():
	$game_over.hide()
	start_game_signal.emit()
	
func game_over():
	$game_over.show()


func _on_game_over_pressed():
	game_over()


func _on_new_game_pressed():
	start_game()
