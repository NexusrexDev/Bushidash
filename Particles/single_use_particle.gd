extends Node2D

@export var _emitter_array: Array[CPUParticles2D] = []
var finished_emitters : int = 0

func _ready() -> void:
	for emitter in _emitter_array:
		emitter.connect("finished", Callable(self, "_on_emitter_finished"))
		emitter.emitting = true

func _on_emitter_finished() -> void:
	finished_emitters += 1
	if finished_emitters == _emitter_array.size():
		queue_free()