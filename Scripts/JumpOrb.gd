extends Area2D

@export var launch_force: float = 800.0
var player_inside: bool = false

@onready var _sfx_jump: AudioStreamPlayer2D = $"../Red cube/SfxJump"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_inside = false

func _process(_delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("jump"):
		activate()
		_sfx_jump.play()

func activate() -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is CharacterBody2D:
			body.velocity.y = -launch_force
