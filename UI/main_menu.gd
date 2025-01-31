extends Control

signal start_game

@export var _can_control : bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and _can_control:
		emit_signal(start_game.get_name())
		SoundManager.play_music(SoundManager.GAME_MUSIC)
		queue_free()