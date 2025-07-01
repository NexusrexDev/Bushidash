extends Control

signal start_game

@export var _can_control : bool = false

func _input(event: InputEvent) -> void:
	var mouse_condition: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
	if mouse_condition and _can_control:
		emit_signal(start_game.get_name())
		SoundManager.play_music(SoundManager.GAME_MUSIC)
		queue_free()