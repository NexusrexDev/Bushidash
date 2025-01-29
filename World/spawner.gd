extends Node

enum EnemyType {
	FOLLOWER,
	FLOATER,
	CHARGER,
	RANGER
}

@export var _spawn_points : Array[Marker2D] = []
@export var _enemy_scenes : Array[PackedScene] = []
@export var _wave_timer : Timer # Used to keep gaps between waves
@export var _pattern_timer : Timer # Used to keep gaps between patterns
@export var _instantiate_timer : Timer # Used to spawn enemies

var _current_wave : int = 0
var _current_pattern : int = 0
var _spawned_enemies : int = 0
var _destroyed_enemies : int = 0

var _pattern : Array = []

func _ready() -> void:
	_wave_timer.start()

func _start_wave() -> void:
	_current_wave += 1
	_current_pattern = 0
	_spawned_enemies = 0
	_destroyed_enemies = 0
	_start_pattern()

func _start_pattern() -> void:
	_current_pattern += 1
	_pattern = _generate_pattern()
	_instantiate_timer.start()

func _generate_pattern() -> Array:
	var available_enemies : Array = _enemy_scenes.slice(0, _current_wave)
	var available_spawn_points : Array = _spawn_points.duplicate()
	var pattern := []
	var max_randi : int = 5
	var pattern_length : int = randi() % max_randi + 1
	for i in range(pattern_length):
		var enemy_type : PackedScene = available_enemies[randi() % available_enemies.size()]
		var spawn_point : Marker2D = available_spawn_points[randi() % available_spawn_points.size()]
		available_spawn_points.erase(spawn_point)
		pattern.append([enemy_type, spawn_point])
	
	return pattern

func _instantiate_enemy() -> void:
	var current_enemy : Array = _pattern.pop_front()
	var enemy_instance : Node2D = current_enemy[0].instantiate()
	var position_offset : Vector2 = Vector2(randf_range(-10, 10), randf_range(-10, 10))
	enemy_instance.position = current_enemy[1].global_position + position_offset
	enemy_instance.connect("destroyed", Callable(self, "_on_enemy_destroyed"))
	get_parent().add_child(enemy_instance)
	_spawned_enemies += 1
	if _pattern.size() == 0:
		_instantiate_timer.stop()

func _on_enemy_destroyed() -> void:
	_destroyed_enemies += 1
	if _destroyed_enemies == _spawned_enemies:
		if _current_pattern <= 3:
			_pattern_timer.start()
		else:
			_wave_timer.start()
