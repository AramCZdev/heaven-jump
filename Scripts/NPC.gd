extends ColorRect

@onready var dialog: Label = $Label

func _ready() -> void:
	dialog.visible = false


func _on_dialog_body_entered(_body: Node2D) -> void:
	dialog.visible = true
