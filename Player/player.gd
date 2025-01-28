extends CharacterBody2D

@export var hp: int = 3

@export var _cooldown_duration : float = 0.75
@export var _cooldown_timer : Timer
@export var _dash_timer : Timer
@export var _iframes_timer : Timer
@export var _attack_area : Area2D
@export var _hurt_area : Area2D

var _can_dash : bool = true
var _is_dashing : bool = false
var _dash_speed : float = 1000
var _target_velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	_attack_area.process_mode = Node.PROCESS_MODE_DISABLED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_click") and _can_dash:
		var mouse_event: InputEventMouse = event
		var direction : Vector2 = (mouse_event.position - position).normalized()

		start_dash(direction)

func start_dash(direction: Vector2) -> void:
	_is_dashing = true
	_can_dash = false

	_target_velocity = direction * _dash_speed
	_dash_timer.start()
	_cooldown_timer.start(_cooldown_duration)

	_attack_area.process_mode = Node.PROCESS_MODE_INHERIT
	_hurt_area.process_mode = Node.PROCESS_MODE_DISABLED

func end_dash() -> void:
	_is_dashing = false
	_target_velocity = Vector2.ZERO
	_attack_area.process_mode = Node.PROCESS_MODE_DISABLED
	_hurt_area.process_mode = Node.PROCESS_MODE_INHERIT

func _on_cooldown_timer_timeout() -> void:
	_can_dash = true

func _physics_process(delta: float) -> void:
	if _is_dashing:
		var coll := move_and_collide(_target_velocity * delta)
		if coll:
			end_dash()

func _on_hurt_area_area_entered(area:Area2D) -> void:
	if area.is_in_group("enemy") and _iframes_timer.is_stopped():
		hp -= 1
		print("HP: ", hp)
		_iframes_timer.start()
		if hp <= 0:
			GameManager.restart_game()
