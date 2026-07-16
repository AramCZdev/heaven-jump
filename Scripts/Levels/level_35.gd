extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer
var is_map_open = false
var animation_played

func _ready() -> void:
	if animation_played:
		$Label.visible = false
	else:
		$Label.visible = true
	$"CanvasLayer/Game menu".process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	$CanvasLayer/Tutorial.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	process_mode = Node.PROCESS_MODE_ALWAYS
	animation.process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer/Map.process_mode = Node.PROCESS_MODE_ALWAYS
	$"Red cube/AudioStreamPlayer2D".process_mode = Node.PROCESS_MODE_ALWAYS

	$CanvasLayer/Map.visible = false
	$CanvasLayer/Tutorial.visible = false
	$Devil.visible = false

func _input(event):
	if get_tree().paused:
		return

	if event.is_action_pressed("open_map"):
		$CanvasLayer/Map.visible = true
		animation.play("map_open")
		is_map_open = true
		get_tree().paused = true


func _on_idk_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		animation.play("begin")
		$"Red cube/AudioStreamPlayer2D".play()
		$Label.visible = false
		$Area2D.move_local_y(-10000)
		animation_played = true


func _on_startsound_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if not $"Red cube/AudioStreamPlayer2D".playing:
			$"Red cube/AudioStreamPlayer2D".play()
			$Label.visible = false


func _on_ok_button_pressed() -> void:
	$CanvasLayer/Tutorial.visible = false
	get_tree().paused = false


func _on_tutorial_body_entered(_body: Node2D) -> void:
	get_tree().paused = true
	$CanvasLayer/Tutorial.visible = true

	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		$CanvasLayer/Tutorial/Tutorial.visible = false
		$CanvasLayer/Tutorial/Tutorial2.visible = true
	else:
		$CanvasLayer/Tutorial/Tutorial.visible = true
		$CanvasLayer/Tutorial/Tutorial2.visible = false
	$Devil/Label.visible = false
	$Devil/Label2.visible = false
	$Devil/Label3.visible = false
func _on_close_pressed() -> void:
	animation.play("map_close")
	is_map_open = false
	get_tree().paused = false


func _on_activate_devil_body_entered(_body: Node2D) -> void:
	$"Activate devil".move_local_y(10000000)
	print("1")
	$Devil.visible = true
	$Devil/Label.visible = true
	await get_tree().create_timer(4).timeout
	print("2")
	$Devil/Label.visible = false
	$Devil/Label2.visible = true
	await get_tree().create_timer(4).timeout
	print("3")
	$Devil/Label2.visible = false
	$Devil/Label3.visible = true
	await get_tree().create_timer(4).timeout
	print("4")
	$Devil.move_local_y(1000000)


func _on_next_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/The Lost Hell/Level35(2).tscn")
