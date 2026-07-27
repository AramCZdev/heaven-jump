extends Control

@onready var level17_btn: Button = $"Control/17"
@onready var level18_btn: Button = $"Control/18"
@onready var level19_btn: Button = $"Control/19"
@onready var level20_btn: Button = $"Control/20"
@onready var level21_btn: Button = $"Control/21"
@onready var level22_btn: Button = $"Control/22"
@onready var level23_btn: Button = $"Control/23"
@onready var level24_btn: Button = $"Control/24"
@onready var level25_btn: Button = $"Control/25"
@onready var level26_btn: Button = $"Control/26"
@onready var level27_btn: Button = $"Control/27"
@onready var level28_btn: Button = $"Control/28"
@onready var level29_btn: Button = $"Control/29"
@onready var level30_btn: Button = $"Control/30"

@onready var secret22_btn: Button = $"Control/22+"
@onready var secret24_btn: Button = $"Control/24+"
@onready var secret27_btn: Button = $"Control/27+"

@onready var no_death_run: Panel = $"No death runs"

func _ready() -> void:
	if SaveManager.is_chapter_unlocked("the_deep_hell, 2"):
		$"No death run".visible = true
	else:
		$"No death run".visible = false
	no_death_run.visible = false
	get_tree().paused = false

	var unlocked := SaveManager.get_unlocked_level("the_hell")
	var buttons := $Control

	for i in range(17, 31):
		buttons.get_node(str(i)).visible = unlocked >= i

		var lock_index := i - 16
		buttons.get_node("Locked" + str(lock_index)).visible = unlocked < i

	var secrets := ["22+", "24+", "27+"]

	for i in range(secrets.size()):
		var unlocked_secret := SaveManager.is_secret_unlocked("the_hell", secrets[i])
		buttons.get_node(secrets[i]).visible = unlocked_secret
		buttons.get_node("Locked" + str(15 + i)).visible = !unlocked_secret
func _on_back_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/level_select.tscn")


func _on__pressed16() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level16.tscn")


func _on__pressed17() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level17.tscn")


func _on__pressed18() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level18.tscn")


func _on__pressed19() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level19.tscn")


func _on__pressed20() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level20.tscn")


func _on__pressed21() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level21.tscn")


func _on__pressed22() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level22.tscn")


func _on__pressed23() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level23.tscn")



func _on__pressed() -> void:
		LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level24.tscn")


func _on__pressed25() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level25.tscn")


func _on__pressed26() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level26.tscn")


func _on__pressed27() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level27.tscn")


func _on__pressed28() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level28.tscn")


func _on__pressed29() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level29.tscn")


func _on__pressed30() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level30.tscn")


func _on__pressed22plus() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level22+.tscn")


func _on__pressed24plus() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level24+.tscn")


func _on__pressed27plus() -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level27+.tscn")

func _on_start_no_death_pressed() -> void:
	MiscManager.start_chapter2_no_death()
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level16.tscn")


func _on_no_death_run_pressed() -> void:
	no_death_run.visible = true


func _on_do_not_pressed() -> void:
	no_death_run.visible = false
