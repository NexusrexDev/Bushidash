extends Control

signal start_game

@export var _can_control : bool = false

var music_mute: bool = false
var sfx_mute: bool = false

func _ready() -> void:
	_load_settings()
	
	# Initialize the music and SFX toggles
	var music_toggle: TextureButton = $VBoxContainer/ButtonContainer/MusicButton
	var sfx_toggle: TextureButton = $VBoxContainer/ButtonContainer/AudioButton
	
	music_toggle.button_pressed = not music_mute
	sfx_toggle.button_pressed = not sfx_mute

func _unhandled_input(event: InputEvent) -> void:
	var mouse_condition: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
	if mouse_condition and _can_control:
		emit_signal(start_game.get_name())
		GameManager.add_count()
		SoundManager.play_music(SoundManager.GAME_MUSIC)
		queue_free()

func _music_toggle(toggled_on: bool) -> void:
	music_mute = not toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), music_mute)
	_save_settings()

func _sfx_toggle(toggled_on: bool) -> void:
	sfx_mute = not toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), sfx_mute)
	_save_settings()

func _save_settings() -> void:
	var file: FileAccess = FileAccess.open("user://settings.cfg", FileAccess.WRITE)
	if file:
		file.store_var({
			"music": music_mute,
			"sfx": sfx_mute,
		})
		file.close()

func _load_settings() -> void:
	var file: FileAccess = FileAccess.open("user://settings.cfg", FileAccess.READ)
	if file:
		var settings: Dictionary = file.get_var()
		music_mute = settings.get("music", false)
		sfx_mute = settings.get("sfx", false)
		file.close()
