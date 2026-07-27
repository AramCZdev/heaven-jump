extends Node

var loading_scene = preload("res://Scenes/Loading.tscn")

var loading_ui: CanvasLayer
var animation: AnimationPlayer

var _loading := false
var _path := ""
var _progress := [0.0]


func goto(path: String) -> void:
	_path = path
	_loading = true

	loading_ui = loading_scene.instantiate()
	get_tree().root.add_child(loading_ui)

	animation = loading_ui.get_node_or_null("AnimationPlayer")

	if animation:
		animation.play("load")

	var err = ResourceLoader.load_threaded_request(path)
	if err != OK:
		push_error("Failed to start threaded load: " + path)
		_cleanup()
		return

	_run_loader()


func _run_loader() -> void:
	while _loading:
		var status = ResourceLoader.load_threaded_get_status(_path, _progress)


		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var packed = ResourceLoader.load_threaded_get(_path)
			_loading = false

			if packed:
				get_tree().change_scene_to_packed(packed)
			else:
				push_error("Loaded scene is null: " + _path)

			_cleanup()
			return

		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Threaded load failed: " + _path)
			_loading = false
			_cleanup()
			return

		await get_tree().process_frame


func _cleanup() -> void:
	if loading_ui:
		loading_ui.queue_free()
	loading_ui = null
	animation = null
	_path = ""
