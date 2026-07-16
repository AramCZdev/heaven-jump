extends Node2D

const CHECKPOINT_FILE = "user://checkpoint.tmp"

@onready var cam1: Camera2D = $"Red cube/Camera2D"
@onready var cam2: Camera2D = $Camera2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var player = $"Red cube"
@onready var popup = $"CanvasLayer/You lost"
@onready var door1: StaticBody2D = $Platform20
@onready var door2: StaticBody2D = $Platform21

var boss_state := "idle"
var cutscene_done := false
var swooned := false
var using_cam1 := true
var checkpoint_saved := false

var spawn_protection := true


func _ready() -> void:
	popup.process_mode = Node.PROCESS_MODE_ALWAYS
	popup.visible = false
	cam1.make_current()
	using_cam1 = true

	spawn_protection = true
	await get_tree().process_frame
	spawn_protection = false

	if FileAccess.file_exists(CHECKPOINT_FILE):
		var file := FileAccess.open(CHECKPOINT_FILE, FileAccess.READ)
		var data = file.get_var()
		file.close()

		if typeof(data) == TYPE_DICTIONARY:

			if data.has("player_pos"):
				player.position = data["player_pos"]

			if data.has("boss_pos"):
				$Boss.position = data["boss_pos"]

			if data.has("using_cam1"):
				using_cam1 = data["using_cam1"]
				if using_cam1:
					cam1.make_current()
				else:
					cam2.make_current()

			if data.get("cutscene_done", false):
				cutscene_done = true
				boss_state = "fight"

	if boss_state == "fight":
		print("READY: Fight state loaded")
		set_doors_closed(true)

		print("READY: Playing Start_boss")
		animation.play("Start_boss")


func switch_camera():
	using_cam1 = !using_cam1

	if using_cam1:
		cam1.make_current()
	else:
		cam2.make_current()


func _on_boss_body_entered(_body: Node2D) -> void:
	if spawn_protection:
		return

	if boss_state != "idle":
		return

	switch_camera()
	boss_state = "cutscene"

	$Boss.move_local_y(10000000)
	$ShadowGuy/Label.visible = true

	animation.play("Start_boss")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Start_boss":
		cutscene_done = true
		save_checkpoint()

		boss_state = "fight"
		set_doors_closed(true)
		start_bossfight()

	elif anim_name == "bossfight":
		animation.play("win")
		SaveManager.unlock_secret("the_hell", "999")
		AchievementManager.unlock("boss_complete")
		$"Red cube/AudioStreamPlayer2D".stop()


func start_bossfight():
	animation.play("bossfight")

	var music = $"Red cube/AudioStreamPlayer2D"
	if music and music.stream and not music.playing:
		music.play()


func set_doors_closed(closed: bool) -> void:
	var val := 1 if closed else 0

	if door1:
		door1.collision_layer = val
		door1.collision_mask = val

	if door2:
		door2.collision_layer = val
		door2.collision_mask = val


func save_checkpoint():
	if checkpoint_saved:
		return

	checkpoint_saved = true

	if FileAccess.file_exists(CHECKPOINT_FILE):
		DirAccess.remove_absolute(CHECKPOINT_FILE)

	var data = {
		"player_pos": player.position,
		"boss_pos": $Boss.position,
		"bossfight_started": true,
		"cutscene_done": true,
		"using_cam1": using_cam1
	}

	var file := FileAccess.open(CHECKPOINT_FILE, FileAccess.WRITE)
	file.store_var(data)
	file.close()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if FileAccess.file_exists(CHECKPOINT_FILE):
			DirAccess.remove_absolute(CHECKPOINT_FILE)
		get_tree().quit()


func _on_spike_body_entered(_body: Node2D) -> void:
	if _body is CharacterBody2D:
		if MiscManager.chapter3_no_death:
			LoadingManager.goto("res://Scenes/Levels/The Lost Hell/Level31.tscn")
		else:
			popup.visible = true
			get_tree().paused = true

func _die():
	AchievementManager.progressachievement("deaths_50", 1)
	AchievementManager.progressachievement("deaths_500", 1)
	AchievementManager.progressachievement("deaths_1000", 1)
	print("Killed by:", get_path())
	print("Player position:", player.global_position)
	$"Red cube/SfxHurt".play()
	swooned = true
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_almost_end_body_entered(_body: Node2D) -> void:
	if _body is CharacterBody2D:
		print("win")
		LoadingManager.goto("res://Scenes/Levels/The Lost Hell/Level35(6).tscn")


func _on_restart_pressed() -> void:
	_die()


func _on_continue_pressed() -> void:
	animation.stop()
	popup.visible = false
	get_tree().paused = false
	$"Red cube/AudioStreamPlayer2D".stop()
	animation.play("lost")
