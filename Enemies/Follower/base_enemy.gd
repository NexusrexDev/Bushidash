extends Area2D

signal destroyed

@export var _sprite : Sprite2D
@export var _score : int = 10
@onready var _animation_player : AnimationPlayer = $AnimationPlayer
var _player : Node
var _explosion_particles : PackedScene = preload("res://Particles/explosion_particle.tscn")

func _ready() -> void:
	_player = get_parent().get_node_or_null("Player")
	#creation animation goes first
	_animation_player.play("waddle")

func _physics_process(delta: float) -> void:
	if _player:
		var direction : Vector2 = (_player.position - position).normalized()
		var velocity : Vector2 = direction * 60
		if direction.x < 0:
			_sprite.flip_h = true
		else:
			_sprite.flip_h = false
		
		position += velocity * delta

func _on_hurt_component_damage() -> void:
	_death()

func _death() -> void:
	emit_signal(destroyed.get_name())
	GameManager.enemy_destroyed(_score)

	var explosion : Node2D = _explosion_particles.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)

	queue_free()
