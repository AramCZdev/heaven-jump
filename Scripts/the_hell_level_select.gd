extends Control

@onready var level2_btn: Button = $"Control/2"
@onready var level3_btn: Button = $"Control/3"
@onready var level4_btn: Button = $"Control/4"
@onready var level5_btn: Button = $"Control/5"
@onready var level6_btn: Button = $"Control/6"
@onready var level7_btn: Button = $"Control/7"
@onready var level8_btn: Button = $"Control/8"
@onready var level9_btn: Button = $"Control/9"
@onready var level10_btn: Button = $"Control/10"
@onready var level11_btn: Button = $"Control/11"
@onready var level12_btn: Button = $"Control/12"
@onready var level13_btn: Button = $"Control/13"
@onready var level14_btn: Button = $"Control/14"
@onready var level15_btn: Button = $"Control/15"

@onready var secret5_btn: Button = $"Control/5+"
@onready var secret8_btn: Button = $"Control/8+"
@onready var secret11_btn: Button = $"Control/11+"

@onready var no_death_run: Panel = $"No death runs"


func _ready() -> void:
	if SaveManager.is_chapter_unlocked("the_deep_hell, 1"):
		$"No death run".visible = true
	else:
		$"No death run".visible = false
	no_death_run.visible = false
	get_tree().paused = false

	var unlocked := SaveManager.get_unlocked_level("the_hell")
	var buttons := $Control

	for i in range(2, 16):
		buttons.get_node(str(i)).visible = unlocked >= i
		buttons.get_node("Locked" if i == 2 else "Locked" + str(i - 1)).visible = unlocked < i

	var secrets := ["5+", "8+", "11+"]

	for i in range(secrets.size()):
		var unlocked_secret := SaveManager.is_secret_unlocked("the_hell", secrets[i])
		buttons.get_node(secrets[i]).visible = unlocked_secret
		buttons.get_node("Locked" + str(15 + i)).visible = !unlocked_secret

func _on__pressed() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level1.tscn")


func _on__pressed_2() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level2.tscn")


func _on_back_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/level_select.tscn")


func _on__pressed3() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level4.tscn")


func _on__pressed4() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/level_3.tscn")


func _on__pressed5() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level5.tscn")


func _on__pressed5p() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level5+.tscn")


func _on__pressed6() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level6.tscn")


func _on__pressed7() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level7.tscn")


func _on__pressed8plus() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level8+.tscn")


func _on__pressed8() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level8.tscn")


func _on__pressed10() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level10.tscn")


func _on__pressed9() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level9.tscn")


func _on__pressed11() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level11.tscn")
	
	
func _on__pressed11plus() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level11+.tscn")


func _on__pressed12() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level12.tscn")


func _on__pressed13() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level13.tscn")


func _on__pressed14() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level14.tscn")


func _on__pressed15() -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level15(1).tscn")

func _on_start_no_death_pressed() -> void:
	MiscManager.start_chapter1_no_death()
	LoadingManager.goto("res://Scenes/Levels/The hell/Level1.tscn")


func _on_no_death_run_pressed() -> void:
	no_death_run.visible = true


func _on_do_not_pressed() -> void:
	no_death_run.visible = false
