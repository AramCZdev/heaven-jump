extends Area2D

const CHECKPOINT_FILE = "user://checkpoint.tmp"
@onready var sprite: ColorRect = $"../Red cube/Node2D/Sprite2D"
@onready var camera: Camera2D = $"../Red cube/Camera2D"

func _ready() -> void:
	var player = get_parent().get_node("Red cube")
	if FileAccess.file_exists(CHECKPOINT_FILE):
		var file := FileAccess.open(CHECKPOINT_FILE, FileAccess.READ)
		var pos = file.get_var()
		var rot = file.get_var()
		file.close()
		if pos is Vector2:
			player.position = pos
		if rot is float:
			sprite.rotation = rot
	$Checkpoint2.visible = false

func _on_body_entered(_body: Node2D) -> void:
	if FileAccess.file_exists(CHECKPOINT_FILE):
		DirAccess.remove_absolute("user://checkpoint.tmp")
	var file := FileAccess.open(CHECKPOINT_FILE, FileAccess.WRITE)
	file.store_var(_body.position)
	file.store_var(sprite.rotation)
	file.close()
	$Checkpoint2.visible = true

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if FileAccess.file_exists(CHECKPOINT_FILE):
			DirAccess.remove_absolute(CHECKPOINT_FILE)
		get_tree().quit()
