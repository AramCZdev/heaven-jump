extends Node2D

@onready var Story: Panel = $Story
@onready var tutorial: Panel = $Tutorial

func _ready() -> void:
	Story.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	Story.visible = true
	tutorial.visible = false
	tutorial.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true

func _on_ok_button_pressed() -> void:
	Story.visible = false
	tutorial.visible = true


func _on_ok_button_pressed2() -> void:
	tutorial.visible = false
	get_tree().paused = false
