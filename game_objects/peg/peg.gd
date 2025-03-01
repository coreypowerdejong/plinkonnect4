extends Sprite2D

signal peg_toggled(state: bool)

var connections = []
var enabled: bool = true
var locked: bool = false
var idx: int
var secret: bool = false:
	set(value):
		if value == true:
			set_color(Color("DIM_GRAY"))

func set_color(color: Color = Color("WHITE")):
	$ColorRect.color = color

func reset():
	if !enabled:
		$CheckButton.set_pressed(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	$CheckButton.disabled = locked


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_check_button_toggled(toggled_on):
	enabled = toggled_on
	if not enabled:
		$ColorRect.hide()
	else:
		$ColorRect.show()
	peg_toggled.emit(toggled_on)
