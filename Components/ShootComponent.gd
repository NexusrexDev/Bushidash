class_name ShootComponent
extends Node2D

@export var _shot_scene : PackedScene

func shoot_at(target: Vector2) -> void:
	var shot := _shot_scene.instantiate()
	shot.position = global_position
	shot.direction = target
	get_parent().get_parent().add_child(shot)