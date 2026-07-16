extends Node2D



func _on_finish_line_body_entered(_body: Node2D) -> void:
	SaveManager.unlock_secret("the_hell", "$")
	AdManager.level_completed()
	LoadingManager.goto("res://Scenes/BonusLevels.tscn")
