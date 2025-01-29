extends Control

@export var _hp_label : Label
@export var _focus_label : Label
@export var _score_label : Label
@export var _combo_label : Label

func _ready() -> void:
	GameManager.connect("score_updated", Callable(self, "_on_score_updated"))
	GameManager.connect("combo_started", Callable(self, "_on_combo_started"))
	GameManager.connect("combo_updated", Callable(self, "_on_combo_updated"))
	GameManager.connect("combo_ended", Callable(self, "_on_combo_end"))
	_hp_label.text = "HP: 3"
	_focus_label.text = "Focus: 100"
	_score_label.text = "Score: 0"
	_combo_label.text = "Combo: x0"

func _on_hp_updated(hp : int) -> void:
	_hp_label.text = "HP: " + str(hp)

func _on_focus_updated(focus : float) -> void:
	_focus_label.text = "Focus: " + str(int(focus * 100))

func _on_score_updated(score : int, _highscore : int) -> void:
	_score_label.text = "Score: " + str(score)

func _on_combo_started() -> void:
	_combo_label.text = "Combo: x1"

func _on_combo_updated() -> void:
	_combo_label.text = "Combo: x" + str(GameManager.combo)

func _on_combo_end() -> void:
	_combo_label.text = "Combo: x0"
