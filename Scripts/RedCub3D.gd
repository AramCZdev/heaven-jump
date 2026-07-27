extends CharacterBody3D

@onready var _sfx_jump: AudioStreamPlayer3D = $SfxJump
@onready var _sfx_hurt: AudioStreamPlayer3D = $SfxHurt

const SPEED = 5.0
const JUMP_VELOCITY = 5.5

func _ready() -> void:
	get_tree().paused = false
	_sfx_hurt.process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump3d") and is_on_floor():
		_sfx_jump.play()
		velocity.y = JUMP_VELOCITY
		

	var input_dir := Input.get_vector("move_left", "move_right", "move_foward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_spike_body_entered(_body: Node3D) -> void:
	if _body is CharacterBody3D:
		_sfx_hurt.play()
		get_tree().paused = true
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()


func _on_win_body_entered(_body: Node3D) -> void:
	if _body is CharacterBody3D:
		AdManager.level_completed()
		SaveManager.unlock_secret("the_hell", "3D")
		LoadingManager.goto("res://Scenes/BonusLevels.tscn")


func _on_win_body_entered2(_body: Node3D) -> void:
	if _body is CharacterBody3D:
		AdManager.level_completed()
		SaveManager.unlock_secret("the_hell", "3D2")
		LoadingManager.goto("res://Scenes/BonusLevels.tscn")
