extends Control

func _ready() -> void:
	$Label.visible = false
	await  get_tree().create_timer(1).timeout
	$Label.visible = true
	await get_tree().create_timer(2).timeout
	if not MiscManager.is_setup_completed():
		LoadingManager.goto("res://Scenes/InitialSetup.tscn")
	else:
		LoadingManager.goto("res://Scenes/MainMenu.tscn")
