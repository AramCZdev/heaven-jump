extends Node2D

@onready var Story: Panel = $Story

func _ready() -> void:
	Story.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	Story.visible = true
	get_tree().paused = true

func _on_ok_button_pressed() -> void:
	Story.visible = false
	get_tree().paused = false
