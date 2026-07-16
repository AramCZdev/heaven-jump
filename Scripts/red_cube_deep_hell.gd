extends CharacterBody2D

@export var gravity: float = 1400.0
@export var walk_speed: float = 300.0
@export var jump_speed: float = 600.0
@export var jumpad_speed: float = 1000.0

var _dashing: bool = false
var _dash_ready: bool = true
var _facing: int = 1
var _dead: bool = false

# Improved Physics
@export var improved_acceleration: float = 5000.0
@export var improved_deceleration: float = 6000.0
@export var improved_coyote_frames: int = 10

@onready var _sprite := $Sprite2D
@onready var _sfx_jump := get_node_or_null("SfxJump") as AudioStreamPlayer2D
@onready var _sfx_dash := get_node_or_null("SfxDash") as AudioStreamPlayer2D
@onready var _sfx_hurt := get_node_or_null("SfxHurt") as AudioStreamPlayer2D
@onready var menu: Panel = $"../Game menu"
@onready var win: Panel = $"../Win Menu"

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
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -jump_speed
			if _sfx_jump:
				_sfx_jump.stop()
				_sfx_jump.play()
				AchievementManager.progressachievement("jumps_50", 1)
				AchievementManager.progressachievement("jumps_500", 1)
				AchievementManager.progressachievement("jumps_1000", 1)
				AchievementManager.progressachievement("jumps_10000", 1)
	else:
		velocity.y = 0
	move_and_slide()

func _start_dash(dir: int) -> void:
	_dashing = true
	_dash_ready = false
	_facing = dir
	velocity.y = 0
	if _sfx_dash:
		_sfx_dash.play()
	_end_dash_async()

func _end_dash_async() -> void:
	_dashing = false
	if _sprite:
		_sprite.rotation = 0.0
	_dash_ready = true

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
	get_tree().paused = false
	MiscManager.end_no_death()
	LoadingManager.goto("res://Scenes/The Deep Hell Level Select.tscn")


func _on_jumpad_body_entered(_body: Node2D) -> void:
	velocity.y = -jumpad_speed
	if _sfx_jump:
		_sfx_jump.stop()
		_sfx_jump.play()


func _on_finish_line_deep_body_entered(_body: Node2D) -> void:
		if not win:
			return
		var paused := not win.visible
		win.visible = paused
		get_tree().paused = paused
		AdManager.level_completed()


func _on_next_pressed16() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 17)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level17.tscn")


func _on_next_pressed17() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 18)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level18.tscn")


func _on_next_pressed18() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 19)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level19.tscn")


func _on_next_pressed() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 20)
	LoadingManager.goto("res://Scenes/Levels/The Deep Hell/Level20.tscn")
