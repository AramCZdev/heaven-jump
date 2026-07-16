extends Node2D

@onready var text1: Node2D = $Room8/Sprite2D4/Node2D


func _ready() -> void:
	text1.visible = false

func _on_activate_text_body_entered(_body: Node2D) -> void:
	text1.visible = true
