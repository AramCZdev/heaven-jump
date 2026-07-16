extends Node2D

func _on_beta1_finish_line_body_entered(_body: Node2D) -> void:
	SaveManager.unlock_secret("the_hell", "beta1")
	LoadingManager.goto("res://Scenes/BonusLevels.tscn")
	AdManager.level_completed()
