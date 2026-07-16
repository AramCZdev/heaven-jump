extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$Spike30.visible = false
	$Label.visible = false
	$Label2.visible = false
	animation.play("begin")

func _on_rooftop_body_entered(_body: Node2D) -> void:
	$"Red cube/wind".play()
	$"Red cube/AudioStreamPlayer2D".stop()


func _on_forced_spike_body_entered(_body: Node2D) -> void:
	if _body is CharacterBody2D:
		$"Red cube/SfxHurt".play()
		$Spike30.visible = true
		animation.play("spikes")
		await get_tree().create_timer(3.1).timeout
		$"Red cube/tatoneimade".play()
		$"Red cube/wind".stop()
		$"Red cube/AudioStreamPlayer2D".stop()
		$Label.visible = true
		await get_tree().create_timer(14).timeout
		$Label2.visible = true


func _on_next_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/The Lost Hell/Level35(3).tscn")


func _on_resume_pressed() -> void:
	pass # Replace with function body.


func _on_restart_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	pass # Replace with function body.
