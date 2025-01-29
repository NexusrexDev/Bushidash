extends Node

signal combo_started
signal combo_ended
signal combo_updated(combo : int)
signal combo_time_updated(time: float)
signal score_updated(score : int, highscore : int)

var score : int = 0
var highscore : int = 0

var combo : int = 0
var combo_time : float = 1.0 : set = _set_combo_time

func _set_combo_time(value : float) -> void:
	combo_time = value
	emit_signal(combo_time_updated.get_name())

func restart_game() -> void:
	score = 0
	combo = 0
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
		emit_signal(combo_updated.get_name())

func reset_combo() -> void:
	combo = 0
	emit_signal(combo_ended.get_name())

func _process(delta : float) -> void:
	if combo > 0:
		combo_time -= 0.8 * delta
		if combo_time <= 0:
			reset_combo()
			combo_time = 1.0
			emit_signal(combo_time_updated.get_name())