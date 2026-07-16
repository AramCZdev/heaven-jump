extends Control

@onready var thedeephell: Control = get_node("Deep Hell")
@onready var thelosthell: Control = get_node("Lost Hell")
@onready var heaven: Control = get_node("Heaven")

func _ready() -> void:
	get_tree().paused = false
	if thedeephell:
		thedeephell.visible = SaveManager.is_chapter_unlocked("the_deep_hell, 1")
		thelosthell.visible = SaveManager.is_chapter_unlocked("the_deep_hell, 2")
		heaven.visible = SaveManager.is_chapter_unlocked("the_deep_hell, 3")

func _on_texture_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/the_hell_level_select.tscn")


func _on_back_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/MainMenu.tscn")


func _on_the_deep_hell_pressed() -> void:
	LoadingManager.goto("res://Scenes/The Deep Hell Level Select.tscn")


func _on_lost_hell_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/The Lost Hell Level Select.tscn")
