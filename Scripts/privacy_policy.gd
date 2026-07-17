extends Control


func _on_read_pressed() -> void:
	OS.shell_open("https://purplecontroller.github.io/helljumpprivacypolicy")


func _on_i_agree_pressed() -> void:
	LoadingManager.goto("res://Scenes/MainMenu.tscn")
