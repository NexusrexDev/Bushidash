class_name MovementComponent
extends Node

@export var movable_body : CharacterBody2D
@export var speed : float = 100.0

func move_body(direction_vector: Vector2) -> void:
	movable_body.velocity = direction_vector * speed
	movable_body.move_and_slide()