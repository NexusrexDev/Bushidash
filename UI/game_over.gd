extends Control

@onready var _animation_player : AnimationPlayer = $AnimationPlayer
@onready var _label : Label = $CenterContainer/Label

@export var _wise_lines : Array[String] = []

func _ready() -> void:
	_animation_player.play("gameover")

func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		_animation_player.play("gameover")

func update_score_label() -> void:
	_label.text = _wise_lines[randi() % _wise_lines.size()] + "\nYour score: " + str(GameManager.score).pad_zeros(6)

func restart() -> void:
	GameManager.restart_game()
