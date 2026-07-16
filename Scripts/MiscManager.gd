extends Node

const SAVE_PATH = "user://setup.cfg"

var _data: Dictionary = {}

var chapter1_no_death := false
var chapter2_no_death := false
var chapter3_no_death := false

func _ready() -> void:
	load_game()

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
