extends Control

func _on_youtube_pressed() -> void:
	OS.shell_open("https://www.youtube.com/@PurpleControllerGames")

func _on_itch_pressed() -> void:
	OS.shell_open("https://purplecontroller.itch.io")

func _on_twitter_pressed() -> void:
	OS.shell_open("https://x.com/helljumpgame")

func _on_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/MainMenu.tscn")


func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/PurpleController")


func _on_aram_cz_games_pressed() -> void:
	OS.shell_open("https://purplecontroller.github.io")


func _on_hell_jump_pressed() -> void:
	OS.shell_open("https://purplecontroller.github.io/helljump")


func _on_ok_site_pressed() -> void:
	$Website.visible = false
