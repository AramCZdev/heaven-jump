extends Node2D

@onready var tutorial: Panel = $Tutorial

func _ready() -> void:
	tutorial.visible = true
	tutorial.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true

func _on_ok_button_pressed() -> void:
	tutorial.visible = false
	get_tree().paused = false
