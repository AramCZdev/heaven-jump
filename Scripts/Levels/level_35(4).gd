extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation.play("spike-wall")


func _on_exit_2_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		LoadingManager.goto("res://Scenes/Levels/The Lost Hell/Level35(5).tscn")
