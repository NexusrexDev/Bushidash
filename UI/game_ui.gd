extends Control

@export var _hp_label : Label
@export var _score_label : Label
@export var _focus_progress_bar : TextureProgressBar

@export_category("Combo Nodes")
@export var _combo_label : Label
@export var _combo_progress_bar : TextureProgressBar
@export var _combo_container : VBoxContainer

func _ready() -> void:
	GameManager.connect("score_updated", Callable(self, "_on_score_updated"))
	GameManager.connect("combo_started", Callable(self, "_on_combo_started"))
	GameManager.connect("combo_updated", Callable(self, "_on_combo_updated"))
	GameManager.connect("combo_ended", Callable(self, "_on_combo_end"))
	GameManager.connect("combo_time_updated", Callable(self, "_on_combo_time_updated"))
	_hp_label.text = "000"
	_focus_progress_bar.value = 100
	_score_label.text = "Score: 000000"

	_combo_label.text = "x0 Combo"
	_combo_progress_bar.value = 1
	_combo_container.visible = false

func show_ui() -> void:
	visible = true

func _on_hp_updated(hp : int) -> void:
	_hp_label.text = "0".repeat(hp)

func _on_focus_updated(focus : float) -> void:
	_focus_progress_bar.value = focus

func _on_score_updated(score : int, _highscore : int) -> void:
	_score_label.text = "Score: " + str(score).pad_zeros(6)

func _on_combo_started() -> void:
	_combo_container.visible = true
	_combo_label.text = "x1 Combo"

func _on_combo_updated(combo : int) -> void:
	_combo_label.text = "x%s Combo" % combo

func _on_combo_end() -> void:
	_combo_container.visible = false
	_combo_label.text = "Combo: x0"

func _on_combo_time_updated(time : float) -> void:
	_combo_progress_bar.value = time