extends Node2D

@onready var text1: Label = $"Yellow Guy/Text"

func _ready() -> void:
	text1.visible = false


func _on_activate_text_1_body_entered(_body: Node2D) -> void:
	text1.visible = true
