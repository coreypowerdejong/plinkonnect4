extends Sprite2D

var type: int = 0:
	set(value):
		if value == 0:
			$ColorRect.color = Color("RED")
		else:
			$ColorRect.color = Color("BLUE")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
