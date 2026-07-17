@tool
extends EditorExportPlugin

const VERSION_FILE_PATH = "/home/aramcz/Documents/GitHub/aramczgames.github.io/helljumpver.txt"

func _export_begin(features, is_debug, path, flags):
	var version = ProjectSettings.get_setting("application/config/version")

	if version == null or str(version).strip_edges() == "":
		version = "0.0.0"

	version = str(version).strip_edges()

	var dir_path = VERSION_FILE_PATH.get_base_dir()

	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)

	var file = FileAccess.open(VERSION_FILE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("File open failed: " + str(FileAccess.get_open_error()))
		return

	file.store_string(version)
	file.close()

	print("Version written:", version)
