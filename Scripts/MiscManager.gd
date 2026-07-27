extends Node

const SAVE_PATH = "user://setup.cfg"

var _data: Dictionary = {}

var chapter1_no_death := false
var chapter2_no_death := false
var chapter3_no_death := false

var has_controller := false
var last_scene: Node = null


func _process(_delta):
	if has_controller:
		refocus_if_needed()
	var current_scene = get_tree().current_scene

	if current_scene != null and current_scene != last_scene:
		last_scene = current_scene

		if has_controller:
			await get_tree().process_frame
			focus_first_button(current_scene)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	load_game()
	init_stats()

	check_controller()
	Input.joy_connection_changed.connect(_on_controller_changed)

func refocus_if_needed() -> void:
	var scene = get_tree().current_scene

	if scene == null:
		return

	var focused = get_viewport().gui_get_focus_owner()

	if focused == null or not focused.is_visible_in_tree():
		await get_tree().process_frame

		scene = get_tree().current_scene

		if scene != null:
			focus_first_button(scene)

func focus_nearest_button(old_button: Control) -> void:
	var buttons: Array[Button] = []

	collect_buttons(get_tree().current_scene, buttons)

	if buttons.is_empty():
		return

	var nearest: Button = buttons[0]
	var distance := old_button.global_position.distance_to(nearest.global_position)

	for button in buttons:
		var new_distance = old_button.global_position.distance_to(button.global_position)

		if new_distance < distance:
			distance = new_distance
			nearest = button

	nearest.grab_focus()

func _input(event):
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_LEFT_Y:
			var scroll = get_viewport().gui_get_focus_owner()

			if scroll:
				var container = find_scroll_container(scroll)

				if container:
					container.scroll_vertical += event.axis_value * 20

func is_controller_connected() -> bool:
	return Input.get_connected_joypads().size() > 0

func find_scroll_container(node: Node) -> ScrollContainer:
	var parent = node.get_parent()

	while parent:
		if parent is ScrollContainer:
			return parent

		parent = parent.get_parent()

	return null

func collect_buttons(node: Node, buttons: Array[Button]) -> void:
	for child in node.get_children():
		if child is Button and child.visible and child.is_visible_in_tree():
			buttons.append(child)

		collect_buttons(child, buttons)


func check_controller() -> void:
	has_controller = Input.get_connected_joypads().size() > 0


func _on_controller_changed(_device: int, connected: bool) -> void:
	has_controller = connected
	print("Controller connected:", connected)

	if connected:
		await get_tree().process_frame
		focus_first_button(get_tree().current_scene)

func focus_first_button(node: Node) -> void:
	for child in node.get_children():
		if child is Button and child.visible and child.is_visible_in_tree():
			print("Trying focus:", child.name)

			child.grab_focus()

			print("Has focus:", child.has_focus())
			return

		focus_first_button(child)


func init_stats() -> void:
	if not _data.has("stats"):
		_data["stats"] = {
			"deaths": 0,
			"jumps": 0,
			"dashes": 0,
			"level_completes": 0
		}
		save_game()


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return

	_data = file.get_var()
	file.close()


func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return

	file.store_var(_data)
	file.close()


func reset() -> void:
	_data = {}
	save_game()


func complete_setup() -> void:
	_data["completed"] = true
	save_game()


func is_setup_completed() -> bool:
	return _data.get("completed", false)


func add_death():
	_data["stats"]["deaths"] += 1
	save_game()


func add_jump():
	_data["stats"]["jumps"] += 1
	save_game()


func add_dash():
	_data["stats"]["dashes"] += 1
	save_game()


func add_level_complete():
	_data["stats"]["level_completes"] += 1
	save_game()


func get_stat(stat_name: String):
	return _data["stats"].get(stat_name, 0)


func start_chapter1_no_death():
	_reset_no_death()
	chapter1_no_death = true


func start_chapter2_no_death():
	_reset_no_death()
	chapter2_no_death = true


func start_chapter3_no_death():
	_reset_no_death()
	chapter3_no_death = true


func end_no_death():
	_reset_no_death()


func _reset_no_death():
	chapter1_no_death = false
	chapter2_no_death = false
	chapter3_no_death = false

func transfer_old_stats() -> void:
	print("TRANSFER BUTTON PRESSED")

	if _data.get("old_stats_transferred", false):
		print("Already transferred")
		return

	var old_jumps = AchievementManager.getachievementprogress("jumps_10000")
	var old_deaths = AchievementManager.getachievementprogress("deaths_1000")

	print("Old jumps:", old_jumps)
	print("Old deaths:", old_deaths)

	_data["stats"]["jumps"] = old_jumps
	_data["stats"]["deaths"] = old_deaths

	_data["old_stats_transferred"] = true
	save_game()

	print("Transfer complete")
	get_tree().reload_current_scene()

func is_old_stats_transferred() -> bool:
	return _data.get("old_stats_transferred", false)
