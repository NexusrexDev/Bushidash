extends Sprite2D

func _process(_delta: float) -> void:
	#rotate the pointer towards the mouse
	var direction : Vector2 = get_global_mouse_position() - global_position
	var angle : float = direction.angle()
	rotation = angle
