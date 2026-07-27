extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Red cube/Node2D/Sprite2D".set_color("ff0004")
	await get_tree().create_timer(5).timeout
	$"Red cube/Node2D/Sprite2D".set_color("000000")
	await get_tree().create_timer(5).timeout
	$"Red cube/Node2D/Sprite2D".set_color("00ff11")
	await get_tree().create_timer(5).timeout
	$"Red cube/Node2D/Sprite2D".set_color("0000ff")
	await get_tree().create_timer(5).timeout
	$"Red cube/Node2D/Sprite2D".set_color("ffb700")
	await get_tree().create_timer(5).timeout


func _on_finish_line_body_entered(_body: Node2D) -> void:
	SaveManager.unlock_secret("the_hell", "dev_lv")
	LoadingManager.goto("res://Scenes/BonusLevels.tscn")
	AdManager.level_completed()
