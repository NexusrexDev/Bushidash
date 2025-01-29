extends Area2D

signal destroyed

@export var _sprite: Sprite2D
@export var _shoot_component: ShootComponent
@export var _shoot_timer: Timer
@export var _score: int = 30

var _player: Node

func _ready() -> void:
	_player = get_parent().get_node_or_null("Player")
	_shoot_timer.start()

func _process(_delta: float) -> void:
	if _player:
		var direction : Vector2 = (_player.position - position).normalized()
		if direction.x < 0:
			_sprite.flip_h = true
		else:
			_sprite.flip_h = false

func _on_shoot_timer_timeout() -> void:
	if _player:
		var direction : Vector2 = (_player.position - position).normalized()
		_shoot_component.shoot_at(direction)
		_shoot_timer.start()

func _on_hurt_component_damage() -> void:
	emit_signal(destroyed.get_name())
	GameManager.enemy_destroyed(_score)
	queue_free()
