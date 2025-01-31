extends Node2D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animation_player.call_deferred("play", "nex_logo")

func play_jingle() -> void:
	SoundManager.play_music(SoundManager.NEX_JINGLE)

func switch_scene() -> void:
	get_tree().change_scene_to_file("res://World/base.tscn")