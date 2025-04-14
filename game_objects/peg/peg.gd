class_name Peg
extends Sprite2D

signal peg_toggled(state: bool)

var connections = []
var enabled: bool = true
var locked: bool = false

var idx: int
var secret: bool = false:
	set(value):
		if value == true:
			hide()

func set_color(color := Color.CORAL):
	$ColorRect.color = color

func reset():
	if !enabled:
		$CheckButton.set_pressed(true)

func clear():
	if enabled and !locked and !secret:
		$CheckButton.set_pressed(false)

func lock():
	$CheckButton.disabled = true

func unlock():
	$CheckButton.disabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$CheckButton.disabled = locked
	set_color(Color.CORAL)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if locked:
		set_color(Color.BLACK)


func _on_check_button_toggled(toggled_on):
	enabled = toggled_on
	if not enabled:
		#$ColorRect.hide()
		set_color(Color.GRAY)
	else:
		#$ColorRect.show()
		set_color(Color.CORAL)
	peg_toggled.emit(toggled_on)
