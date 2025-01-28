extends Node

func restart_game() -> void:
	get_tree().call_deferred("reload_current_scene")