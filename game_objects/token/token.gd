extends Sprite2D

var type: int = 0:
	set(value):
		if value == 0:
			$Sprite2D/ColorRect.color = Color("RED")
		else:
			$Sprite2D/ColorRect.color = Color("DODGER_BLUE")
signal landed
signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func bounce_animation(path: Array):
	var current_node = path[0]
	var prev_node
	var tween = get_tree().create_tween()
	var position_tracker: Vector2 = position
	scale = Vector2.ONE * 0.5
	for node in path.slice(1):
		prev_node = current_node
		current_node = node
		if current_node.position.x < prev_node.position.x:
			position_tracker += Vector2(-22.5, -22.5)
			tween.tween_property(
				$".",
				"position",
				position_tracker,
				0.5)
			position_tracker += Vector2(-22.5, 135 - 22.5)
			tween.tween_property(
				$".",
				"position",
				position_tracker,
				0.5)
		else:
			position_tracker += Vector2(22.5, -22.5)
			tween.tween_property(
				$".",
				"position",
				position_tracker,
				0.5)
			position_tracker += Vector2(22.5, 135 - 22.5)
			tween.tween_property(
				$".",
				"position",
				position_tracker,
				0.5)
	tween.tween_callback(landed.emit)
	for i in range(4):
		tween.tween_callback($".".hide)
		tween.tween_interval(0.3)
		tween.tween_callback($".".show)
		tween.tween_interval(0.3)
	tween.tween_callback($".".queue_free)

func flash_animation():
	var tween = get_tree().create_tween()
	tween.tween_callback($".".show)
	for i in range(4):
		tween.tween_callback($".".hide)
		tween.tween_interval(0.3)
		tween.tween_callback($".".show)
		tween.tween_interval(0.3)
	tween.tween_callback(finished.emit)
