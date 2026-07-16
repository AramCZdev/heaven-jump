extends Area2D

@export var scroll_speed: float = 60.0

func _process(delta: float) -> void:
	position.y -= scroll_speed * delta
