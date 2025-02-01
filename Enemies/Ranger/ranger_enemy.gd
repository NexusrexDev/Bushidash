extends Area2D

signal destroyed

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@export var _sprite: Sprite2D
@export var _shoot_component: ShootComponent
@export var _shoot_timer: Timer
@export var _shoot_time : float = 1
@export var _score: int = 30

@export_category("SFX")
@export var _charge_sfx : AudioStream
@export var _shoot_sfx : AudioStream
@export var _death_sfx : AudioStream

var _player: Node
var _explosion_particles : PackedScene = preload("res://Particles/explosion_particle.tscn")

func _ready() -> void:
	_player = get_parent().get_node_or_null("Player")
	_sprite.scale = Vector2(2, 0)
	_animation_player.play("intro")

func _start_action() -> void:
	_shoot_time = 1 - clamp(((GameManager.current_wave-3) * 0.1), 0, 0.4)
	_on_shoot_timer_timeout()

func _process(_delta: float) -> void:
	if _player:
		var direction : Vector2 = (_player.position - position).normalized()
		if direction.x < 0:
			_sprite.flip_h = true
		else:
			_sprite.flip_h = false

func _on_shoot_timer_timeout() -> void:
	_animation_player.play("shoot")
	SoundManager.play_sfx(_charge_sfx)

func shoot() -> void:
	if _player:
		var direction : Vector2 = (_player.position - position).normalized()
		_shoot_component.shoot_at(direction)
		_shoot_timer.start(_shoot_time)

		SoundManager.play_sfx(_shoot_sfx)

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
