extends Area2D

signal destroyed

@export var _move_timer : Timer
@export var _ray_north : RayCast2D
@export var _ray_east : RayCast2D
@export var _ray_south : RayCast2D
@export var _ray_west : RayCast2D

@export var _move_speed : float = 100

var _direction : Vector2 = Vector2.ZERO
var _can_move : bool = false

func _ready() -> void:
	_move_timer.start()

func _on_move_timer_timeout() -> void:
	if _can_move:
		_can_move = false

		_move_timer.wait_time = 0.5
		_move_timer.start()
		return

	_set_direction()
	
	_can_move = true

	_move_timer.wait_time = 0.6
	_move_timer.start()

func _set_direction() -> void:
	_direction = Vector2.ZERO

	if _ray_north.is_colliding():
		_direction.y += 1
	if _ray_east.is_colliding():
		_direction.x -= 1
	if _ray_south.is_colliding():
		_direction.y -= 1
	if _ray_west.is_colliding():
		_direction.x += 1

	_direction = _direction.normalized()

	# randomize the direction with 30 degrees
	if _direction != Vector2.ZERO:
		_direction = _direction.rotated(randf_range(-PI/6, PI/6))
	else:
		_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _physics_process(delta: float) -> void:
	if _can_move:
		position += _direction * _move_speed * delta

func _on_hurt_component_damage() -> void:
	emit_signal(destroyed.get_name())
	queue_free()
