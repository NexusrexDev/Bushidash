extends CharacterBody2D

signal hp_updated(hp: int)
signal focus_updated(focus: float)

@export var hp: int = 3 : set = _set_hp
@export var focus: float = 1 : set = _set_focus

@export var _iframes_timer : Timer
@export var _attack_area : Area2D
@export var _hurt_component : HurtComponent
@export var sprite : Sprite2D

@onready var _animation_player : AnimationPlayer = $AnimationPlayer

var _can_dash : bool = true
var _is_dashing : bool = false
var _dash_speed : float = 1000
var _target_velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	_attack_area.process_mode = Node.PROCESS_MODE_DISABLED

func _set_hp(value: int) -> void:
	hp = value
	emit_signal(hp_updated.get_name(), hp)

func _set_focus(value: float) -> void:
	focus = clampf(value, 0, 1)
	emit_signal(focus_updated.get_name(), focus)

func _process(delta: float) -> void:
	if not _can_dash:
		focus += (1.5 + (GameManager.combo * 0.5)) * delta
		if is_equal_approx(focus, 1):
			focus = 1
			_can_dash = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_click") and _can_dash:
		var mouse_event: InputEventMouse = event
		var direction : Vector2 = (mouse_event.position - position).normalized()

		start_dash(direction)

func start_dash(direction: Vector2) -> void:
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	_is_dashing = true
	_can_dash = false

	_target_velocity = direction * _dash_speed
	focus = 0

	_attack_area.process_mode = Node.PROCESS_MODE_INHERIT
	_hurt_component.process_mode = Node.PROCESS_MODE_DISABLED
	_animation_player.play("RESET")

func end_dash() -> void:
	_is_dashing = false
	_target_velocity = Vector2.ZERO
	_attack_area.process_mode = Node.PROCESS_MODE_DISABLED
	_hurt_component.process_mode = Node.PROCESS_MODE_INHERIT
	_animation_player.play("idle")

func _on_cooldown_timer_timeout() -> void:
	_can_dash = true

func _physics_process(delta: float) -> void:
	if _is_dashing:
		var speed : float = _target_velocity.length()
		speed = max(0, speed - 4000 * delta)
		_target_velocity = _target_velocity.normalized() * speed

		var coll := move_and_collide(_target_velocity * delta)
		if coll or speed <= 0:
			end_dash()

func _on_hurt_component_damage() -> void:
	if _iframes_timer.is_stopped():
		hp -= 1
		GameManager.reset_combo()
		_iframes_timer.start()
		if hp <= 0:
			GameManager.restart_game()
