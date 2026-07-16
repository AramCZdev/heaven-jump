extends Node2D

@onready var challenge: Label = $"Challange accepted"
@onready var animation: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	challenge.visible = false

func _on_nocheck_body_entered(_body: Node2D) -> void:
	if _body is CharacterBody2D:
		challenge.visible = true
		$Platform14.global_position = $Marker2D.global_position
	else:
		pass

func _on_checkpoint_body_entered(_body: Node2D) -> void:
	$Marker2D.move_local_x(10000)
	challenge.global_position = $Marker2D2.global_position


func _on_activate_elevator_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		$"Activate Elevator".move_local_y(10000)
		animation.play("Elevator")
