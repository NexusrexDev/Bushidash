extends Line2D

@export var MAX_POINTS: int = 4
var point_queue: Array = []

func _process(_delta: float) -> void:
	point_queue.push_front(get_parent().position)
	if points.size() > MAX_POINTS:
		point_queue.pop_back()
	
	clear_points()

	for point: Vector2 in point_queue:
		add_point(point)

func stop() -> void:
	process_mode = PROCESS_MODE_DISABLED
	clear_points()
	queue_free()
