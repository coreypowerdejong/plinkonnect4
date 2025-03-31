extends Sprite2D

var type: int = 0:
	set(value):
		if value == 0:
			$Sprite2D/ColorRect.color = Color("RED")
		else:
			$Sprite2D/ColorRect.color = Color("DODGER_BLUE")
signal landed
signal finished
const HEIGHT_OFFSET = Vector2(0, 20)

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func tween_to_position(tween, pos: Vector2, time: float = 0.5, ease_in: bool = true):
	var ease = Tween.EASE_IN if ease_in else Tween.EASE_OUT
	tween.tween_property(
				$".",
				"position",
				pos,
				time).set_trans(Tween.TRANS_QUAD).set_ease(ease)

func bounce_animation(path: Array):
	var current_node = path[0]
	var prev_node
	var tween = get_tree().create_tween()
	global_position = current_node.global_position - HEIGHT_OFFSET
	var position_tracker: Vector2 = position
	var direction: int = 1
	scale = Vector2.ONE * 0.5
	show()
	for node in path.slice(1):
		prev_node = current_node
		current_node = node
		
		# direction makes the token fall left or right
		direction = sign(current_node.position.x - prev_node.position.x)
		position_tracker += Vector2(direction * 22.5, -22.5)
		tween_to_position(tween, position_tracker, 0.35, false)
		position_tracker = current_node.position - HEIGHT_OFFSET
		tween_to_position(tween, position_tracker, 0.75)

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
