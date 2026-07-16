extends StaticBody2D

@export var scroll_speed: float = 300

func _process(delta: float) -> void:
	position.y -= scroll_speed * delta
