extends CharacterBody2D

signal destroyed

@onready var _animation_player : AnimationPlayer = $AnimationPlayer
@export var _sprite : Sprite2D
@export var _charge_timer : Timer
@export var _charge_speed : float = 350
@export var _charge_timer_duration : float = 0.5
@export var _score : int = 20

@export_category("SFX")
@export var _charge_sfx : AudioStream
@export var _run_sfx : AudioStream
@export var _wall_hit_sfx : AudioStream
@export var _death_sfx : AudioStream

var _player : Node
var _charge_velocity : Vector2
var _is_charging : bool = false
var _explosion_particles : PackedScene = preload("res://Particles/explosion_particle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player = get_parent().get_node_or_null("Player")
	if _player:
		_sprite.flip_h = (_player.position.x < position.x)
	_sprite.scale = Vector2(2, 0)
	$Sprite2D/DustParticles.visible = false
	_animation_player.play("intro")

func _start_action() -> void:
	_charge_timer_duration = 0.5 - clamp(((GameManager.current_wave-3) * 0.05), 0, 0.2)
	_charge_speed = 350 + clamp(((GameManager.current_wave-3) * 20), 0, 360)
	_animation_player.speed_scale = 1.2 + clamp(((GameManager.current_wave-3) * 0.2), 0, 1)
	_on_charge_timer_timeout()

func _physics_process(delta: float) -> void:
	# move towards the player if the object still exists
	if _is_charging:
		var coll := move_and_collide(_charge_velocity * delta)
		if coll:
			end_charge()

func _on_charge_timer_timeout() -> void:
	_animation_player.play("start_charge")
	SoundManager.play_sfx(_charge_sfx)
	if _player:
		_sprite.flip_h = (_player.position.x < position.x)

func start_charge() -> void:
	if _player:
		_charge_velocity = (_player.position - position).normalized() * _charge_speed
		_sprite.flip_h = (_charge_velocity.x < 0)
		_is_charging = true
		_animation_player.play("charge")
		SoundManager.play_sfx(_run_sfx)

func end_charge() -> void:
	_is_charging = false
	_charge_velocity = Vector2.ZERO
	_charge_timer.start(_charge_timer_duration)
	_animation_player.play("RESET")
	GameManager.screen_shake(1.5)
	SoundManager.play_sfx(_wall_hit_sfx)

func _on_hurt_component_damage() -> void:
	_death()

func _death() -> void:
	emit_signal(destroyed.get_name())
	GameManager.enemy_destroyed(_score)
	GameManager.hitstop(0.1, 0.05)
	GameManager.screen_shake(1.5)

	var explosion : Node2D = _explosion_particles.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)

	SoundManager.play_sfx(_death_sfx)

	queue_free()