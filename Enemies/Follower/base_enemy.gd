extends Area2D

@export var _player : Node

func _ready() -> void:
	_player = get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	# move towards the player if the object still exists
	if _player:
		var direction : Vector2 = (_player.position - position).normalized()
		var velocity : Vector2 = direction * 50
		
		position += velocity * delta

func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group("player_attack"):
		queue_free()
