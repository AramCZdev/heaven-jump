extends CharacterBody2D

const CHECKPOINT_FILE = "user://checkpoint.tmp"
@export var gravity: float = 1400.0
@export var walk_speed: float = 300.0
@export var jump_speed: float = 600.0
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.12
@export var dash_cooldown: float = 0.35
@export var sprite_spin_speed: float = 14.0
@export var coyote_frames: int = 6
@export var jumpad_speed: float = 1000.0

# Improved physics
@export var improved_acceleration: float = 5000.0
@export var improved_deceleration: float = 6000.0
@export var improved_coyote_frames: int = 10

var _dashing: bool = false
var _dash_ready: bool = true
var _dash_timer: float = 0.0
var _facing: int = 1
var _dead: bool = false
var _coyote_timer: int = 0
var _was_on_floor: bool = false

@onready var _sprite := $Node2D
@onready var _sfx_jump := get_node_or_null("SfxJump") as AudioStreamPlayer2D
@onready var _sfx_dash := get_node_or_null("SfxDash") as AudioStreamPlayer2D
@onready var _sfx_hurt := get_node_or_null("SfxHurt") as AudioStreamPlayer2D
@onready var menu: Panel = $"../CanvasLayer/Game menu"
@onready var win: Panel = $"../CanvasLayer/Win Menu"
@onready var camera: Camera2D = $"../Red cube/Camera2D"

func _ready() -> void:
	get_tree().paused = false
	win.visible = false
	win.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	menu.visible = false
	menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	if _sfx_hurt:
		_sfx_hurt.process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	if _dead:
		return
	
	if _dashing:
		_dash_timer += delta
		if _dash_timer >= dash_duration:
			_dashing = false
			_dash_timer = 0.0
			if _sprite:
				_sprite.rotation = 0.0
	
	var dir := Input.get_axis("move_left", "move_right")
	if dir != 0:
		_facing = sign(dir)
	if not _dashing:
		if SettingsManager.is_improved_physics():
			if dir != 0:
				velocity.x = move_toward(
					velocity.x,
					dir * walk_speed,
					improved_acceleration * delta
				)
			else:
				velocity.x = move_toward(
					velocity.x,
					0.0,
					improved_deceleration * delta
				)
		else:
			velocity.x = dir * walk_speed

		velocity.y += gravity * delta

		if is_on_floor():
			_coyote_timer = improved_coyote_frames if SettingsManager.is_improved_physics() else coyote_frames
			_was_on_floor = true
			_dash_ready = true
		elif _was_on_floor:
			_coyote_timer -= 1
			if _coyote_timer <= 0:
				_was_on_floor = false

		var can_jump := is_on_floor() or _coyote_timer > 0
		if Input.is_action_just_pressed("jump") and can_jump:
			velocity.y = -jump_speed
			_coyote_timer = 0
			_was_on_floor = false
			if _sfx_jump:
				_sfx_jump.stop()
				_sfx_jump.play()
				AchievementManager.progressachievement("jumps_50", 1)
				AchievementManager.progressachievement("jumps_500", 1)
				AchievementManager.progressachievement("jumps_1000", 1)
				AchievementManager.progressachievement("jumps_10000", 1)
		if Input.is_action_just_pressed("dash") and _dash_ready:
			var dash_dir := _facing
			if dir != 0:
				dash_dir = sign(dir)
			_start_dash(dash_dir)
	else:
		velocity.x = dash_speed * _facing
		velocity.y = 0
		if _sprite:
			_sprite.rotation += sprite_spin_speed * delta * _facing
	move_and_slide()

func _start_dash(dir: int) -> void:
	_dashing = true
	_dash_ready = false
	_dash_timer = 0.0
	_facing = dir
	velocity.x = dash_speed * dir
	if _sfx_dash:
		_sfx_dash.play()

func _on_spike_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not _dead:
		_die()

func _die() -> void:
	_dead = true
	velocity = Vector2.ZERO
	if _sfx_hurt:
		_sfx_hurt.play()
		AchievementManager.progressachievement("deaths_50", 1)
		AchievementManager.progressachievement("deaths_500", 1)
		AchievementManager.progressachievement("deaths_1000", 1)
	get_tree().paused = true
	var timer := get_tree().create_timer(1.0, true)
	timer.timeout.connect(_reload_room)
	
func _reload_room() -> void:
	if MiscManager.chapter2_no_death:
		get_tree().paused = false
		LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level16.tscn")
	else:
		get_tree().paused = false
		get_tree().reload_current_scene()

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		if not menu:
			return
		var paused := not menu.visible
		menu.visible = paused
		get_tree().paused = paused

func _on_resume_pressed() -> void:
	if menu:
		menu.visible = false
	get_tree().paused = false

func _on_restart_pressed() -> void:
	get_tree().paused = false

	if MiscManager.chapter2_no_death:
		LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level16.tscn")
	else:
		get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	if FileAccess.file_exists(CHECKPOINT_FILE):
		DirAccess.remove_absolute("user://checkpoint.tmp")
	get_tree().paused = false
	MiscManager.end_no_death()
	LoadingManager.goto("res://Scenes/The Deep Hell Level Select.tscn")

func _on_finish_line_body_entered(_body: Node2D) -> void:
	if not win:
		return
	var paused := not win.visible
	win.visible = paused
	get_tree().paused = paused
	AdManager.level_completed()

func _process(_delta: float) -> void:
	if menu.visible:
		menu.global_position = camera.global_position - Vector2(menu.size / 2)

func _on_jumpad_body_entered(_body: Node2D) -> void:
	velocity.y = -jumpad_speed
	if _sfx_jump:
		_sfx_jump.stop()
		_sfx_jump.play()

func _on_next_pressed20() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 21)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level21.tscn")

func _on_next_pressed21() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 22)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level22.tscn")

func _on_next_pressed22() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 23)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level23.tscn")

func _on_next_pressed23() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 24)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level24.tscn")

func _on_next_pressed24() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 25)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level25.tscn")

func _on_next_pressed25() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 26)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level26.tscn")

func _on_next_pressed26() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 27)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level27.tscn")

func _on_clinic_body_entered(_body: Node2D) -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level28 (2).tscn")

func _on_next_pressed27() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 28)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level28.tscn")

func _on_next_pressed28() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 29)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level29.tscn")

func _on_next_pressed29() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 30)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level30.tscn")

func _on_continue_body_entered(_body: Node2D) -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level30(2).tscn")

func _on_exit_body_entered(_body: Node2D) -> void:
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level30(3).tscn")

func _on_finish_line_body_entered22plus(_body: Node2D) -> void:
	if not SaveManager.is_secret_unlocked("the_hell", "22+_complete"):
		SaveManager.unlock_secret("the_hell", "22+_complete")
		AchievementManager.progressachievement("deep_hell_plus_complete", 1)
	if not win:
		return
	var paused := not win.visible
	win.visible = paused
	get_tree().paused = paused

func _on_secret_exit_body_entered1(_body: Node2D) -> void:
	SaveManager.unlock_secret("the_hell", "22+")
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level22+.tscn")

func _on_secret_exit_body_entered24(_body: Node2D) -> void:
	SaveManager.unlock_secret("the_hell", "24+")
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level24+.tscn")

func _on_finish_line_body_entered24plus(_body: Node2D) -> void:
	if not SaveManager.is_secret_unlocked("the_hell", "24+_complete"):
		SaveManager.unlock_secret("the_hell", "24+_complete")
		AchievementManager.progressachievement("deep_hell_plus_complete", 1)
	if not win:
		return
	var paused := not win.visible
	win.visible = paused
	get_tree().paused = paused

func _on_secret_exit_body_entered27plus(_body: Node2D) -> void:
	if FileAccess.file_exists(CHECKPOINT_FILE):
		DirAccess.remove_absolute("user://checkpoint.tmp")
	SaveManager.unlock_secret("the_hell", "27+")
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level27+.tscn")

func _on_finish_line_body_entered27plus(_body: Node2D) -> void:
	if not SaveManager.is_secret_unlocked("the_hell", "27+_complete"):
		SaveManager.unlock_secret("the_hell", "27+_complete")
		AchievementManager.progressachievement("deep_hell_plus_complete", 1)
	if FileAccess.file_exists(CHECKPOINT_FILE):
		DirAccess.remove_absolute("user://checkpoint.tmp")
	if not win:
		return
	var paused := not win.visible
	win.visible = paused
	get_tree().paused = paused
