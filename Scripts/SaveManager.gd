extends Node

const SAVE_PATH = "user://savegame.cfg"

var _data: Dictionary = {}

func _ready() -> void:
	load_game()

func unlock_level(chapter: String, level: int) -> void:
	if not _data.has(chapter):
		_data[chapter] = {}
	var current = _data[chapter].get("unlocked", 1)
	if level > current:
		_data[chapter]["unlocked"] = level
	save_game()

func get_unlocked_level(chapter: String) -> int:
	return _data.get(chapter, {}).get("unlocked", 1)

func unlock_secret(chapter: String, level: String) -> void:
	if not _data.has(chapter):
		_data[chapter] = {}
	_data[chapter]["secret_" + level] = true
	save_game()

func is_secret_unlocked(chapter: String, level: String) -> bool:
	return _data.get(chapter, {}).get("secret_" + level, false)

func unlock_chapter(chapter: String) -> void:
	if not _data.has(chapter):
		_data[chapter] = {}
	_data[chapter]["unlocked"] = true
	save_game()

func is_chapter_unlocked(chapter: String) -> bool:
	return _data.get(chapter, {}).get("unlocked", false)

func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(_data)
	file.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	_data = file.get_var()
	file.close()

func reset() -> void:
	_data = {}
	save_game()
