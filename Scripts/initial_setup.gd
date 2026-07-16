extends Control
@onready var step1: Control = $Step1
@onready var step2: Control = $Step2
@onready var step4: Control = $Step4
@onready var step5: Control = $Step5
@onready var display_dropdown: OptionButton = $"Step2/Video/Window settings"
@onready var language_dropdown: OptionButton = $"Step2/Language/Language Settings"
var _loading: bool = false
func _ready() -> void:
	var saved_index_language = SettingsManager.get_setting("language", 0)

	language_dropdown.selected = saved_index_language
	_on_language_settings_item_selected(saved_index_language)

	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		var saved_index = SettingsManager.get_setting("window_mode", 0)
		display_dropdown.selected = saved_index
		_on_window_settings_item_selected(saved_index)

	step1.visible = true
	step2.visible = false
	step4.visible = false
	step5.visible = false
func _on_setup_pressed() -> void:
	step1.visible = false
	step2.visible = true
	step4.visible = false
	step5.visible = false
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		$Step2/Video.visible = false
	else:
		$Step2/Video.visible = true

func _on_skip_pressed() -> void:
	MiscManager.complete_setup()
	LoadingManager.goto("res://Scenes/PrivacyPolicy.tscn")

func _on_window_settings_item_selected(index: int) -> void:
	SettingsManager.set_setting("window_mode", index)
	match index:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_music_slider_value_changed(value: float) -> void:
	if _loading:
		return
	SettingsManager.set_setting("music_volume", value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	if _loading:
		return
	SettingsManager.set_setting("sfx_volume", value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func _on_next_pressed() -> void:
	step1.visible = false
	step2.visible = false
	step4.visible = true
	
func _on_next_pressed2() -> void:
		step1.visible = false
		step2.visible = false
		step4.visible = true
func _on_unlock_all_pressed() -> void:
	SaveManager.unlock_level("the_hell", 35)
	SaveManager.unlock_chapter("the_deep_hell, 1")
	SaveManager.unlock_chapter("the_deep_hell, 2")
	SaveManager.unlock_chapter("the_deep_hell, 3")
	SaveManager.unlock_secret("the_hell", "5+")
	SaveManager.unlock_secret("the_hell", "11+")
	SaveManager.unlock_secret("the_hell", "8+")
	SaveManager.unlock_secret("the_hell", "22+")
	SaveManager.unlock_secret("the_hell", "27+")
	SaveManager.unlock_secret("the_hell", "24+")
	step1.visible = false
	step2.visible = false
	step4.visible = false
	step5.visible = true
func _on_start_lv_1_pressed() -> void:
	step1.visible = false
	step2.visible = false
	step4.visible = false
	step5.visible = true
func _on_play_pressed() -> void:
	LoadingManager.goto("res://Scenes/PrivacyPolicy.tscn")
	MiscManager.complete_setup()

func _on_language_settings_item_selected(index: int) -> void:
	SettingsManager.set_setting("language", index)
	match index:
		0: TranslationServer.set_locale("en_US")
		1: TranslationServer.set_locale("en_GB")
		3: TranslationServer.set_locale("cs_CZ")
