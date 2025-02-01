extends Area2D

signal destroyed

@export var _sprite : Sprite2D
@export var _score : int = 10
@onready var _animation_player : AnimationPlayer = $AnimationPlayer
@export var _speed : float = 60
var _player : Node
var _started : bool = false
var _explosion_particles : PackedScene = preload("res://Particles/explosion_particle.tscn")

@export_category("SFX")
@export var _death_sfx : AudioStream

func _ready() -> void:
	_player = get_parent().get_node_or_null("Player")
	_sprite.scale = Vector2(2, 0)
	_animation_player.play("intro")

func _start_action() -> void:
	_started = true
	_speed = 60 + clamp(((GameManager.current_wave-3)* 20), 0, 60)
	_animation_player.speed_scale = 1.2 + clamp(((GameManager.current_wave-3) * 0.2), 0, 1)
	_animation_player.play("waddle")

func _physics_process(delta: float) -> void:
	if _started and _player:
		var direction : Vector2 = (_player.position - position).normalized()
		var velocity : Vector2 = direction * _speed
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
	GameManager.hitstop(0.1, 0.05)
	GameManager.screen_shake(2.5)

	var explosion : Node2D = _explosion_particles.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)

	SoundManager.play_sfx(_death_sfx)

	queue_free()
