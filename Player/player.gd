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

@export_category("SFX")
@export var _hit_sfx : AudioStream
@export var _dash_sfx : AudioStream
@export var _focus_full_sfx : AudioStream

var _can_dash : bool = true
var _is_dashing : bool = false
var _dash_speed : float = 1000
var _target_velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	_attack_area.process_mode = Node.PROCESS_MODE_DISABLED
	(sprite.material as ShaderMaterial).set_shader_parameter("active", false)

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
			SoundManager.play_sfx(_focus_full_sfx)
			_can_dash = true

func _input(event: InputEvent) -> void:
	var mouse_condition: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
	if mouse_condition:
		if _can_dash:
			var mouse_position : Vector2 = get_global_mouse_position()
			var direction : Vector2 = (mouse_position - position).normalized()

			start_dash(direction)
		else:
			if GameManager.combo > 0:
				GameManager.reset_combo()

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
	SoundManager.play_sfx(_dash_sfx)

func end_dash() -> void:
	_is_dashing = false
	_target_velocity = Vector2.ZERO
	_attack_area.process_mode = Node.PROCESS_MODE_DISABLED
	_hurt_component.process_mode = Node.PROCESS_MODE_INHERIT
	_animation_player.play("idle")

func _on_cooldown_timer_timeout() -> void:
	_can_dash = true

func _on_iframe_timer_timeout() -> void:
	(sprite.material as ShaderMaterial).set_shader_parameter("active", false)

func _physics_process(delta: float) -> void:
	if _is_dashing:
		var speed : float = _target_velocity.length()
		speed = max(0, speed - 4000 * delta)
		_target_velocity = _target_velocity.normalized() * speed

		var coll := move_and_collide(_target_velocity * delta)
		if coll or speed <= 0:
			end_dash()

func _on_hurt_component_damage() -> void:
	if not _iframes_timer.is_stopped():
		return

	(sprite.material as ShaderMaterial).set_shader_parameter("active", true)

	if hp > 1:
		hp -= 1
		GameManager.reset_combo()
		GameManager.hitstop(0.1, 0.25)
		GameManager.screen_shake(4)
		_iframes_timer.start()
		SoundManager.play_sfx(_hit_sfx)
	else:
		SoundManager.stop_music()
		SoundManager.stop_all_sfx()
		SoundManager.play_sfx(_hit_sfx)
		get_tree().paused = true
