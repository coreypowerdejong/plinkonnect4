extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func set_percentage(count: int, total: int):
	var percentage = float(count) / float(total) * 100
	var pc_string = str(round(percentage)) + "%"
	$Label.text = pc_string
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
