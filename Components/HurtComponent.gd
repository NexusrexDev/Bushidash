class_name HurtComponent
extends Area2D

signal damage

@export var _damage_group: StringName

func _ready() -> void:
    connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group(_damage_group):
        emit_signal(damage.get_name())