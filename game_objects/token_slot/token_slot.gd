extends Node2D

signal activated(id: int)
signal mouse_entered(id: int)
signal mouse_exited(id: int)

var id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_pressed():
	activated.emit(id)

func lock():
	$Button.disabled = true

func unlock():
	$Button.disabled = false


func _on_button_mouse_entered():
	mouse_entered.emit(id)


func _on_button_mouse_exited():
	mouse_exited.emit(id)
