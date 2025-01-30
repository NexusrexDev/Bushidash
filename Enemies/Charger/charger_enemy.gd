extends CharacterBody2D

signal destroyed

@onready var _animation_player : AnimationPlayer = $AnimationPlayer
@export var _sprite : Sprite2D
@export var _charge_timer : Timer
@export var _charge_speed : float = 350
@export var _score : int = 20

var _player : Node
var _charge_velocity : Vector2
var _is_charging : bool = false
var _explosion_particles : PackedScene = preload("res://Particles/explosion_particle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player = get_parent().get_node_or_null("Player")
	#Spawn anim goes here
	_charge_timer.start()
	if _player:
		_sprite.flip_h = (_player.position.x < position.x)

func _physics_process(delta: float) -> void:
	# move towards the player if the object still exists
	if _is_charging:
		var coll := move_and_collide(_charge_velocity * delta)
		if coll:
			end_charge()

func _on_charge_timer_timeout() -> void:
	_animation_player.play("start_charge")
	if _player:
		_sprite.flip_h = (_player.position.x < position.x)

func start_charge() -> void:
	if _player:
		_charge_velocity = (_player.position - position).normalized() * _charge_speed
		_sprite.flip_h = (_charge_velocity.x < 0)
		_is_charging = true
		_animation_player.play("charge")

func end_charge() -> void:
	_is_charging = false
	_charge_velocity = Vector2.ZERO
	_charge_timer.start()
	_animation_player.play("RESET")
	GameManager.screen_shake(1.5)

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

	queue_free()