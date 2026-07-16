extends Control

var game_version: String = ProjectSettings.get_setting("application/config/version") as String
const VERSION_URL := "https://aramczdev.github.io/helljumpver.txt?v=1"

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var update_button: Button = $"Main menu/Update"

@onready var main_menu: Control = $"Main menu"
@onready var settings_menu: Control = $Settings
@onready var play: Control = $Play
@onready var socials: Control = $Socials

@onready var display_dropdown: OptionButton = $"Settings/Video/Window settings"
@onready var music_slider: HSlider = $"Settings/Volume/Music Slider"
@onready var sfx_slider: HSlider = $"Settings/Volume/SFX Slider"
@onready var language_dropdown: OptionButton = $"Settings/Language/Language settings"
@onready var resolution_dropdown: OptionButton = $"Settings/Video/Resolution"
@onready var improved_physics_button: CheckButton = $Settings2/Developer/ImprovedPhysics

@onready var delete_warning: Panel = $"Settings2/Danger Zone/Warning"
@onready var video: Node2D = $Settings/Video

@onready var quit: Button = $"Main menu/Quit"

@onready var admob: Admob = $Admob

var _consent_status: String = UserConsent.status_to_string(UserConsent.Status.UNKNOWN):
	set(a_value):
		_consent_status = a_value

var _loading := false


func _ready() -> void:
	var saved_resolution = SettingsManager.get_setting("resolution", 0)
	resolution_dropdown.selected = saved_resolution
	_on_resolution_settings_item_selected(saved_resolution)
	
	$Settings2.visible = false
	
	improved_physics_button.button_pressed = SettingsManager.is_improved_physics()
	
	var saved_index_language = SettingsManager.get_setting("language", 0)
	language_dropdown.selected = saved_index_language
	_on_language_settings_item_selected(saved_index_language)
	
	$"Main menu/Label2".visible = false

	update_button.hide()

	await get_tree().process_frame
	http_request.request(VERSION_URL)
	
	$Website.visible = false
	_loading = true
	$AramCz.visible = false
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$"Main menu/Support".visible = true
		$"Main menu/Quit".visible = false
	else:
		var saved_index = SettingsManager.get_setting("window_mode", 0)
		display_dropdown.selected = saved_index
		_on_window_settings_item_selected(saved_index)
		$"Main menu/Support".visible = false

	main_menu.visible = true
	settings_menu.visible = false
	play.visible = false
	delete_warning.visible = false

	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(music_slider.value)
	)

	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(sfx_slider.value)
	)

	AchievementManager.unlockachievement("hell_jump")

	_loading = false

	var error := http_request.request(VERSION_URL)
	print("Request error:", error)

	await get_tree().create_timer(60).timeout
	$AramCz.visible = true
	await get_tree().create_timer(5).timeout
	$AramCz.visible = false

func _on_options_button_pressed() -> void:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		$Settings/Video.visible = false
	settings_menu.visible = true
	play.visible = false
	socials.visible = false
	$Settings2.visible = false


func _on_back_button_pressed() -> void:
	settings_menu.visible = false
	play.visible = false
	socials.visible = true
	delete_warning.visible = false
	$Settings2.visible = false


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	settings_menu.visible = false
	play.visible = true
	socials.visible = false
	$Settings2.visible = false


func _on_window_settings_item_selected(index: int) -> void:
	SettingsManager.set_setting("window_mode", index)

	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			resolution_dropdown.visible = true
			$Settings/Video/Video2.visible = true

		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			resolution_dropdown.visible = false
			$Settings/Video/Video2.visible = false

		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			resolution_dropdown.visible = false
			$Settings/Video/Video2.visible = false


func _on_credits_pressed() -> void:
	LoadingManager.goto("res://Scenes/Credits.tscn")


func _on_achievements_pressed() -> void:
	LoadingManager.goto("res://addons/SimpleAchievement/ui/AchievementViewer.tscn")


func _on_sfx_slider_value_changed(value: Variant = null) -> void:
	print("SFX:", value)
	if _loading:
		return
	if value == null:
		return
	SettingsManager.set_setting("sfx_volume", value)


func _on_music_slider_value_changed(value: Variant = null) -> void:
	print("Music:", value)
	if _loading:
		return
	if value == null:
		return
	SettingsManager.set_setting("music_volume", value)


func _on_warning_pressed() -> void:
	delete_warning.visible = true


func _on_reset_pressed() -> void:
	SaveManager.reset()
	SettingsManager.reset()
	AchievementManager.reset()
	MiscManager.reset()
	admob.reset_consent_info()
	get_tree().quit()


func _on_campaign_pressed() -> void:
	LoadingManager.goto("res://Scenes/level_select.tscn")


func _on_yt_pressed() -> void:
	OS.shell_open("youtube.com/@AramCZGames")


func _on_x_pressed() -> void:
	OS.shell_open("x.com/AramCZGames")


func _on_itch_pressed() -> void:
	OS.shell_open("aramczgames.itch.io")


func _on_aram_cz_games_pressed() -> void:
	$Website.visible = true


func _on_hell_jump_pressed() -> void:
	$Website.visible = true


func _on_ok_site_pressed() -> void:
	$Website.visible = false


func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/AramCZdev")


func _on_update_pressed() -> void:
	OS.shell_open("https://aramczgames.itch.io/hell-jump")

func _on_version_request_completed(
	_result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	if response_code != 200:
		return

	var latest_version := body.get_string_from_utf8().strip_edges()

	print("Current:", game_version)
	print("Latest:", latest_version)
	print("NEWER:", version_is_newer(latest_version, game_version))

	if version_is_newer(latest_version, game_version):
		update_button.show()


func version_is_newer(latest: String, current: String) -> bool:
	var latest_parts := latest.split(".")
	var current_parts := current.split(".")

	var count := maxi(latest_parts.size(), current_parts.size())

	for i in range(count):
		var latest_num := 0
		var current_num := 0

		if i < latest_parts.size():
			latest_num = int(latest_parts[i])

		if i < current_parts.size():
			current_num = int(current_parts[i])

		if latest_num > current_num:
			return true
		elif latest_num < current_num:
			return false

	return false

func _on_admob_initialization_completed(status_data: InitializationStatus) -> void:
	for __network_tag in status_data.get_network_tags():
		var __adapter_status: AdapterStatus = status_data.get_adapter_status(__network_tag)
		print(
			(
				"Network '%s' (%s) status: %s [Latency: %d, Description: %s]"
				% [
					__network_tag,
					__adapter_status.get_adapter_class(),
					__adapter_status.get_initialization_state(),
					__adapter_status.get_latency(),
					__adapter_status.get_description(),
				]
			),
		)
	_process_consent_status(admob.get_consent_status())

func _process_consent_status(a_consent_status: UserConsent) -> void:
	_consent_status = a_consent_status.to_status_string()
	match a_consent_status.status:
		UserConsent.Status.UNKNOWN:
			print("consent status is unknown")
			admob.update_consent_info()
		UserConsent.Status.NOT_REQUIRED:
			print("consent is not required")
			_load_ads()
		UserConsent.Status.REQUIRED:
			print("consent is required")
			admob.load_consent_form()
		UserConsent.Status.OBTAINED:
			print("consent has been obtained")
			(
				admob
				. set_mediation_privacy_settings(
					(
						NetworkPrivacySettings
						. new()
						. set_has_gdpr_consent(true)
						. set_is_age_restricted_user(false)
						. set_has_ccpa_sale_consent(true)
					),
				)
			)
			_load_ads()

func _load_ads() -> void:
	admob.load_rewarded_ad()

func _on_admob_consent_form_loaded() -> void:
	print("consent form has been loaded")
	admob.show_consent_form()


func _on_admob_consent_form_failed_to_load(a_error_data: FormError) -> void:
	print("consent form failed to load %s" % a_error_data.get_message())


func _on_admob_consent_form_dismissed(a_error_data: FormError) -> void:
	print("consent form has been dismissed %s" % a_error_data.get_message())
	_process_consent_status(admob.get_consent_status())

func _on_admob_consent_info_updated() -> void:
	print("consent info updated")
	_process_consent_status(admob.get_consent_status())


func _on_admob_consent_info_update_failed(a_error_data: FormError) -> void:
	print("consent info failed to update: %s" % a_error_data.get_message())


func _on_manage_ads_pressed() -> void:
	print("UMP Loading")
	admob.load_consent_form()


func _on_support_pressed() -> void:
	if admob.is_rewarded_ad_loaded():
		admob.show_rewarded_ad()
		admob.load_rewarded_ad()
	else:
		print("Rewarded ad not ready")
		admob.load_rewarded_ad()
		$"Main menu/Label2".visible = true
		await get_tree().create_timer(3).timeout
		$"Main menu/Label2".visible = false


func _on_play_bonus_pressed() -> void:
	LoadingManager.goto("res://Scenes/BonusLevels.tscn")


func _on_language_settings_item_selected(index: int) -> void:
	SettingsManager.set_setting("language", index)
	match index:
		0: TranslationServer.set_locale("en_US")
		1: TranslationServer.set_locale("en_GB")
		3: TranslationServer.set_locale("cs_CZ")

func _on_improved_physics_button_toggled(button_pressed: bool) -> void:
	SettingsManager.set_setting("improved_physics", button_pressed)


func _on_page_1_pressed() -> void:
	$Settings2.visible = false
	settings_menu.visible = true


func _on_page_2_pressed() -> void:
	$Settings2.visible = true
	settings_menu.visible = false

func _on_resolution_settings_item_selected(index: int) -> void:
	SettingsManager.set_setting("resolution", index)

	match index:
		0: DisplayServer.window_set_size(Vector2i(1152, 648))
		1: DisplayServer.window_set_size(Vector2i(1280, 720))
		2: DisplayServer.window_set_size(Vector2i(1600, 900))
		3: DisplayServer.window_set_size(Vector2i(1920, 1080))
		4: DisplayServer.window_set_size(Vector2i(3840, 2160))
