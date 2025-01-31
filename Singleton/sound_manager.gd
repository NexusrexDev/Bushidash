extends Node

var _sfx_players : Array[AudioStreamPlayer] = []
var _music_player : AudioStreamPlayer

func _ready() -> void:
	for i : int in range(16):
		var player : AudioStreamPlayer = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_sfx_players.append(player)
	
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)

	process_mode = PROCESS_MODE_ALWAYS

func play_sfx(sound : AudioStream) -> void:
	for player : AudioStreamPlayer in _sfx_players:
		if not player.playing:
			player.stream = sound
			player.play()
			_sfx_players.erase(player)
			_sfx_players.append(player)
			return

func play_music(music : AudioStream) -> void:
	_music_player.stream = music
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()