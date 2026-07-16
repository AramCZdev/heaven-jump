extends Node2D

@onready var timer: Timer = $Timer

func _on_the_deep_hell_entrance_body_entered(_body: Node2D) -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level30(6).tscn")



func _on_activate_body_entered(_body: Node2D) -> void:
	timer.start()


func _on_timer_timeout() -> void:
	if MiscManager.chapter2_no_death:
		AchievementManager.unlock("the_deep_hell_no_death_run")
		MiscManager.end_no_death()
	SaveManager.unlock_level("the_hell", 31)
	SaveManager.unlock_chapter("the_deep_hell, 2")
	AchievementManager.unlockachievement("deep_hell_complete")
	LoadingManager.goto("res://Scenes/The Lost Hell Level Select.tscn")


func _on_exit_body_entered(_body: Node2D) -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level30(4).tscn")


func _on_exit_body_entered2(_body: Node2D) -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level30(5).tscn")
