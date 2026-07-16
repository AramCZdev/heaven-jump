extends Node2D

@onready var story: Panel = $CanvasLayer/Story

func _ready() -> void:
	story.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	story.visible = true
	get_tree().paused = true

func _on_ok_button_pressed() -> void:
	get_tree().paused = false
	story.visible = false
