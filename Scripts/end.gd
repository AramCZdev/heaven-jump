extends Control

func _ready() -> void:
	$Website.visible = false

func _on_youtube_pressed() -> void:
	OS.shell_open("https://www.youtube.com/@AramCZGames")

func _on_itch_pressed() -> void:
	OS.shell_open("https://aramczgames.itch.io")

func _on_twitter_pressed() -> void:
	OS.shell_open("https://x.com/helljumpgame")

func _on_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/MainMenu.tscn")


func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/AramCZGames")


func _on_aram_cz_games_pressed() -> void:
	$Website.visible = true


func _on_hell_jump_pressed() -> void:
	$Website.visible = true


func _on_ok_site_pressed() -> void:
	$Website.visible = false
