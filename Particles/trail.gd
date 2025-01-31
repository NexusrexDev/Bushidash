extends Line2D

@export var MAX_POINTS: int = 2
var _point_queue: Array = []
var _timer : Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.wait_time = 0.05
	_timer.one_shot = false
	_timer.connect("timeout", Callable(self, _update_trail.get_method()))
	add_child(_timer)
	_timer.start()

func _update_trail() -> void:
	_point_queue.push_front(get_parent().position)
	if points.size() > MAX_POINTS:
		_point_queue.pop_back()
	
	clear_points()

	for point: Vector2 in _point_queue:
		add_point(point)

func stop() -> void:
	process_mode = PROCESS_MODE_DISABLED
	clear_points()
	queue_free()
