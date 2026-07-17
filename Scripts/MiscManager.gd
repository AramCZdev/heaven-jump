extends Node

const SAVE_PATH = "user://setup.cfg"

var _data: Dictionary = {}

var chapter1_no_death := false
var chapter2_no_death := false
var chapter3_no_death := false


func _ready() -> void:
	load_game()
	init_stats()


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
