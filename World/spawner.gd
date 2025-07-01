extends Node

@export var _spawn_points : Array[Marker2D] = []
@export var _enemy_scenes : Array[PackedScene] = []
@export var _wave_timer : Timer # Used to keep gaps between waves
@export var _pattern_timer : Timer # Used to keep gaps between patterns
@export var _instantiate_timer : Timer # Used to spawn enemies

var _current_pattern : int = 0
var _target_enemies : int = 0
var _destroyed_enemies : int = 0

var _pattern : Array = []

func start_game() -> void:
	_wave_timer.start()

func _start_wave() -> void:
	GameManager.current_wave += 1
	_current_pattern = 0
	_start_pattern()

func _start_pattern() -> void:
	_current_pattern += 1
	_target_enemies = 0
	_destroyed_enemies = 0
	_pattern = _generate_pattern()
	_instantiate_timer.start()

func _generate_pattern() -> Array:
	var available_enemies : Array = _enemy_scenes.slice(0, GameManager.current_wave)
	var available_spawn_points : Array = _spawn_points.duplicate()

	if GameManager.current_wave <= 3:
		return _early_patterns(available_enemies, available_spawn_points)
	else:
		return _late_patterns(available_enemies, available_spawn_points)

func _early_patterns(available_enemies: Array, available_spawn_points: Array) -> Array:
	var pattern := []
	if _current_pattern == 1:
		var first_enemy : PackedScene = available_enemies[GameManager.current_wave - 1]
		var spawn_point : Marker2D = available_spawn_points[randi() % available_spawn_points.size()]
		pattern.append([first_enemy, spawn_point])
	else:
		var max_randi : int = 3 if randi() % 101 <= 90 else 4
		var min_randi : int = 2
		_target_enemies = randi_range(min_randi, max_randi)

		for i in range(_target_enemies):
			var select_showcase_enemy : bool = randi() % 2 == 0
			var enemy_type : PackedScene
			var spawn_point : Marker2D = available_spawn_points[randi() % available_spawn_points.size()]

			if select_showcase_enemy:
				enemy_type = available_enemies[GameManager.current_wave - 1]
			else:
				enemy_type = available_enemies[randi() % available_enemies.size()]
			
			available_spawn_points.erase(spawn_point)
			pattern.append([enemy_type, spawn_point])
		
	_target_enemies = pattern.size()
	return pattern

func _late_patterns(available_enemies: Array, available_spawn_points: Array) -> Array:
	var pattern := []
	var max_randi : int = 5 if randi() % 101 <= 95 else 7
	var min_randi : int = clamp(3 + int((GameManager.current_wave - 3) / 3.0), 3, max_randi)
	_target_enemies = randi_range(min_randi, max_randi)

	for i in range(_target_enemies):
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
	if _pattern.size() == 0:
		_instantiate_timer.stop()

func _on_enemy_destroyed() -> void:
	_destroyed_enemies += 1
	if _destroyed_enemies == _target_enemies:
		if _current_pattern <= 2:
			_pattern_timer.start()
		else:
			_wave_timer.start()
