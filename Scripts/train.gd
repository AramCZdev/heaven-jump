extends StaticBody2D

@export var scroll_speed: float = 250.0

func _process(delta: float) -> void:
	position.x += scroll_speed * delta
