extends Control

func _ready() -> void:
	get_window().set_flag(Window.FLAG_MAXIMIZE_DISABLED, true)

	# Apply language
	var saved_language = SettingsManager.get_setting("language", 0)

	match saved_language:
		0:
			TranslationServer.set_locale("en_US")
		1:
			TranslationServer.set_locale("en_GB")
		3:
			TranslationServer.set_locale("cs_CZ")

	# Apply resolution
	var saved_resolution = SettingsManager.get_setting("resolution", 0)

	match saved_resolution:
		0:
			get_window().size = Vector2i(1152, 648)
		1:
			get_window().size = Vector2i(1280, 720)
		2:
			get_window().size = Vector2i(1600, 900)
		3:
			get_window().size = Vector2i(1920, 1080)
		4:
			get_window().size = Vector2i(3840, 2160)
	
	var saved_window_mode = SettingsManager.get_setting("window_mode", 0)

	match saved_window_mode:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

	$Label.visible = false
	await get_tree().create_timer(1).timeout
	$Label.visible = true

	await get_tree().create_timer(2).timeout

	if not MiscManager.is_setup_completed():
		LoadingManager.goto("res://Scenes/InitialSetup.tscn")
	else:
		LoadingManager.goto("res://Scenes/MainMenu.tscn")
