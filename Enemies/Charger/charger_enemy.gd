extends CharacterBody2D

signal destroyed

@export var _sprite : Sprite2D
@export var _charge_timer : Timer
@export var _charge_speed : float = 350
@export var _score : int = 20

var _player : Node
var _charge_velocity : Vector2
var _is_charging : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player = get_parent().get_node_or_null("Player")
	_charge_timer.start()
	if _player:
		if _player.position.x < position.x:
			_sprite.flip_h = true

func _physics_process(delta: float) -> void:
	# move towards the player if the object still exists
	if _is_charging:
		if _charge_velocity.x < 0:
			_sprite.flip_h = true
		else:
			_sprite.flip_h = false
		var coll := move_and_collide(_charge_velocity * delta)
		if coll:
			end_charge()

func _on_charge_timer_timeout() -> void:
	if _player:
		_charge_velocity = (_player.position - position).normalized() * _charge_speed
		_is_charging = true

func end_charge() -> void:
	_is_charging = false
	_charge_velocity = Vector2.ZERO
	_charge_timer.start()

func _on_hurt_component_damage() -> void:
	emit_signal(destroyed.get_name())
	GameManager.enemy_destroyed(_score)
	queue_free()
