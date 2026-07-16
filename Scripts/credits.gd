extends Node2D

@export var scroll_speed: float = 80.0

func _process(delta: float) -> void:
	position.y -= scroll_speed * delta


func _on_timer_timeout() -> void:
	LoadingManager.goto("res://Scenes/End.tscn")


func _on_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/End.tscn")


func _on_normal_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/MainMenu.tscn")


func _on_normal_timer_timeout() -> void:
	LoadingManager.goto("res://Scenes/MainMenu.tscn")
