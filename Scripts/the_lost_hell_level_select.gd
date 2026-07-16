extends Control

@onready var level32_btn: Button = $"Control/32"
@onready var level33_btn: Button = $"Control/33"
@onready var level34_btn: Button = $"Control/34"
@onready var level35_btn: Button = $"Control/35"

@onready var no_death_run: Panel = $"No death runs"

func _ready() -> void:
	no_death_run.visible = false
	get_tree().paused = false

	var unlocked := SaveManager.get_unlocked_level("the_hell")
	var buttons := $Control

	var btn31 := buttons.get_node("31")
	btn31.visible = true

	for i in range(32, 36):
		var btn := buttons.get_node(str(i))
		btn.visible = unlocked >= i

		var lock_index := i - 30
		var lock := buttons.get_node_or_null("Locked" + str(lock_index))

		if lock:
			lock.visible = unlocked < i


func _on_back_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/level_select.tscn")


func _on__pressed31() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Lost Hell/Level31.tscn")


func _on__pressed32() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Lost Hell/Level32.tscn")


func _on__pressed33() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Lost Hell/Level33.tscn")


func _on__pressed34() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Lost Hell/Level34.tscn")


func _on__pressed35() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Lost Hell/Level35.tscn")

func _on_start_no_death_pressed() -> void:
	MiscManager.start_chapter3_no_death()
	LoadingManager.goto("res://Scenes/Levels/The Lost Hell/Level31.tscn")


func _on_no_death_run_pressed() -> void:
	no_death_run.visible = true


func _on_do_not_pressed() -> void:
	no_death_run.visible = false
