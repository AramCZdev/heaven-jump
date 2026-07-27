extends CharacterBody2D

@export var gravity: float = 1400.0
@export var walk_speed: float = 300.0
@export var jump_speed: float = 600.0
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.12
@export var dash_cooldown: float = 0.35
@export var sprite_spin_speed: float = 14.0

@export var coyote_frames: int = 6

# Improved Physics
@export var improved_acceleration: float = 3500.0
@export var improved_deceleration: float = 7000.0
@export var improved_coyote_frames: int = 10

@onready var _sprite := $Node2D
@onready var _sfx_jump := get_node_or_null("SfxJump") as AudioStreamPlayer2D
@onready var _sfx_dash := get_node_or_null("SfxDash") as AudioStreamPlayer2D
@onready var _sfx_hurt := get_node_or_null("SfxHurt") as AudioStreamPlayer2D

@onready var menu: Panel = $"../Game menu"
@onready var win: Panel = $"../Win Menu"

var _dashing: bool = false
var _dash_ready: bool = true
var _dash_timer: float = 0.0
var _facing: int = 1
var _dead: bool = false
var _coyote_timer: int = 0
var _was_on_floor: bool = false

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

			if SettingsManager.is_improved_physics():
				velocity.x = _facing * walk_speed

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


		var current_coyote_frames = coyote_frames

		if SettingsManager.is_improved_physics():
			current_coyote_frames = improved_coyote_frames


		if is_on_floor():
			_coyote_timer = current_coyote_frames
			_was_on_floor = true
			_dash_ready = true

		elif _was_on_floor:
			_coyote_timer -= 1

			if _coyote_timer <= 0:
				_was_on_floor = false


		var can_jump := is_on_floor() or _coyote_timer > 0

		if Input.is_action_just_pressed("jump") and can_jump:
			MiscManager.add_jump()
			AchievementManager.progressachievement("jumps_50", 1)
			AchievementManager.progressachievement("jumps_500", 1)
			AchievementManager.progressachievement("jumps_1000", 1)
			AchievementManager.progressachievement("jumps_10000", 1)
			velocity.y = -jump_speed
			_coyote_timer = 0
			_was_on_floor = false

			if _sfx_jump:
				_sfx_jump.stop()
				_sfx_jump.play()


		if Input.is_action_just_pressed("dash") and _dash_ready:
			MiscManager.add_dash()
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
	MiscManager.add_death()
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
	if MiscManager.chapter1_no_death:
		get_tree().paused = false
		LoadingManager.goto("res://Scenes/Levels/The hell/Level1.tscn")
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

	if MiscManager.chapter1_no_death:
		LoadingManager.goto("res://Scenes/Levels/The hell/Level1.tscn")
	else:
		get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false

	MiscManager.end_no_death()
	LoadingManager.goto("res://Scenes/the_hell_level_select.tscn")
	
func _on_secret_exit_body_entered(_body: Node2D) -> void:
	if MiscManager.chapter1_no_death:
		LoadingManager.goto("res://Scenes/Levels/The hell/Level6.tscn")
	else:
		SaveManager.unlock_secret("the_hell", "5+")
		LoadingManager.goto("res://Scenes/Levels/The hell/Level5+.tscn")

func _on_finish_line_body_entered(_body: Node2D) -> void:
	MiscManager.add_level_complete()
	if not win:
		return
	var paused := not win.visible
	win.visible = paused
	get_tree().paused = paused
	AdManager.level_completed()

func _on_secret_exit_8_body_entered(_body: Node2D) -> void:
	if MiscManager.chapter1_no_death:
		LoadingManager.goto("res://Scenes/Levels/The hell/Level9.tscn")
	else:
		SaveManager.unlock_secret("the_hell", "8+")
		LoadingManager.goto("res://Scenes/Levels/The hell/Level8+.tscn")

func _on_secret_exit_11_body_entered(_body: Node2D) -> void:
	if MiscManager.chapter1_no_death:
		LoadingManager.goto("res://Scenes/Levels/The hell/Level12.tscn")
	else:
		SaveManager.unlock_secret("the_hell", "11+")
		LoadingManager.goto("res://Scenes/Levels/The hell/Level11+.tscn")

func _on_easter_egg_body_entered(_body: Node2D) -> void:
	AchievementManager.unlockachievement("wrong_path")
	LoadingManager.goto("res://Scenes/HelloSimon.tscn")

func _on_exit_body_entered151(_body: Node2D) -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level15(2).tscn")

func _on_exit_body_entered152(_body: Node2D) -> void:
	LoadingManager.goto("res://Scenes/Levels/The hell/Level15(3).tscn")

func _on_the_deep_hell_entrance_body_entered(_body: Node2D) -> void:
	if MiscManager.chapter1_no_death:
		MiscManager.end_no_death()
		AchievementManager.unlock("the_hell_no_death_run")
	SaveManager.unlock_chapter("the_deep_hell, 1")
	LoadingManager.goto("res://Scenes/The Deep Hell Level Select.tscn")

func _on_next_pressed() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 2)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level2.tscn")

func _on_next_pressed2() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 3)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level4.tscn")

func _on_next_pressed3() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 4)
	LoadingManager.goto("res://Scenes/Levels/The hell/level_3.tscn")

func _on_next_pressed4() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 5)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level5.tscn")

func _on_next_pressed5() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 6)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level6.tscn")

func _on_next_pressed6() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 7)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level7.tscn")

func _on_next_pressed7() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 8)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level8.tscn")

func _on_next_pressed8() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 9)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level9.tscn")

func _on_next_pressed9() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 10)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level10.tscn")

func _on_next_pressed10() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 11)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level11.tscn")

func _on_next_pressed11() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 12)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level12.tscn")

func _on_next_pressed12() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 13)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level13.tscn")

func _on_next_pressed13() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 14)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level14.tscn")

func _on_next_pressed14() -> void:
	get_tree().paused = false
	SaveManager.unlock_level("the_hell", 15)
	LoadingManager.goto("res://Scenes/Levels/The hell/Level15(1).tscn")

func _on_achievment_body_entered(_body: Node2D) -> void:
	AchievementManager.unlock("hell_complete")

func _on_finish_line_body_entered5plus(_body: Node2D) -> void:
	MiscManager.add_level_complete()
	if not SaveManager.is_secret_unlocked("the_hell", "5+_complete"):
		SaveManager.unlock_secret("the_hell", "5+_complete")
		AchievementManager.progressachievement("hell_plus_complete", 1)
	if not win:
		return
	var paused := not win.visible
	win.visible = paused
	get_tree().paused = paused

func _on_finish_line_body_entered8plus(_body: Node2D) -> void:
	MiscManager.add_level_complete()
	if not SaveManager.is_secret_unlocked("the_hell", "8+_complete"):
		SaveManager.unlock_secret("the_hell", "8+_complete")
		AchievementManager.progressachievement("hell_plus_complete", 1)
	if not win:
		return
	var paused := not win.visible
	win.visible = paused
	get_tree().paused = paused

func _on_finish_line_body_entered11plus(_body: Node2D) -> void:
	MiscManager.add_level_complete()
	if not SaveManager.is_secret_unlocked("the_hell", "11+_complete"):
		SaveManager.unlock_secret("the_hell", "11+_complete")
		AchievementManager.progressachievement("hell_plus_complete", 1)
	if not win:
		return
	var paused := not win.visible
	win.visible = paused
	get_tree().paused = paused

func _on_finish_line_body_entered8plusbonus(_body: Node2D) -> void:
	if _body is CharacterBody2D:
		AdManager.level_completed()
		SaveManager.unlock_secret("the_hell", "Beta8+")
		LoadingManager.goto("res://Scenes/BonusLevels.tscn")
