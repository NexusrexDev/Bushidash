extends Node

signal combo_started
signal combo_ended
signal combo_updated(combo : int)
signal combo_time_updated(time: float)
signal score_updated(score : int, highscore : int)

const COMBO_END_SFX : AudioStream = preload("res://UI/combo_ended.wav")

var score : int = 0
var highscore : int = 0

var combo : int = 0
var combo_time : float = 1.0 : set = _set_combo_time

var _camera : Camera2D
var _shake_value : float = 0.0
var _default_timescale : float = 1.0

var current_wave : int = 0

func _ready() -> void:
	_camera = Camera2D.new()
	_camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	add_child(_camera)
	process_mode = PROCESS_MODE_ALWAYS

func _set_combo_time(value : float) -> void:
	combo_time = value
	emit_signal(combo_time_updated.get_name(), combo_time)

func restart_game() -> void:
	score = 0
	combo = 0
	current_wave = 0
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().call_deferred("reload_current_scene")

func enemy_destroyed(amount : int) -> void:
	increase_score(amount)
	increase_combo()

func increase_score(amount : int) -> void:
	score += amount * (1 + combo)
	if score > highscore:
		highscore = score
	emit_signal(score_updated.get_name(), score, highscore)

func increase_combo() -> void:
	combo += 1
	combo_time = 1.0
	if combo == 1:
		emit_signal(combo_started.get_name())
	else:
		emit_signal(combo_updated.get_name(), combo)

func reset_combo() -> void:
	combo = 0
	combo_time = 1.0
	if not get_tree().paused:
		SoundManager.play_sfx(COMBO_END_SFX)
	emit_signal(combo_ended.get_name())

func hitstop(timescale: float, duration : float) -> void:
	Engine.time_scale = timescale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = _default_timescale

func screen_shake(value : float) -> void:
	_shake_value = value

func _handle_combo_time(delta : float) -> void:
	if combo > 0:
		combo_time -= 0.8 * delta
		if combo_time <= 0:
			reset_combo()
			combo_time = 1.0

func _handle_screen_shake(delta : float) -> void:
	if _shake_value > 0:
		_shake_value = max(0, _shake_value - delta * 10)
		_camera.offset.x = randf_range(-_shake_value, _shake_value)
		_camera.offset.y = randf_range(-_shake_value, _shake_value)

func _process(delta : float) -> void:
	_handle_combo_time(delta)
	_handle_screen_shake(delta)