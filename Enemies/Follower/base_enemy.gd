extends Area2D

signal destroyed

@export var _sprite : Sprite2D
@export var _score : int = 10
var _player : Node

func _ready() -> void:
	_player = get_parent().get_node_or_null("Player")

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
	emit_signal(destroyed.get_name())
	GameManager.enemy_destroyed(_score)
	queue_free()
