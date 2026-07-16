extends Node2D

@onready var cam1: Camera2D = $"Red cube/Camera2D"
@onready var cam2: Camera2D = $Camera2D
var using_cam1 := true

func _ready() -> void:
	cam1.make_current()
	using_cam1 = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body is CharacterBody2D:
		$Area2D.move_local_y(1000000000000000)
		using_cam1 = !using_cam1

		if using_cam1:
			cam1.make_current()
		else:
			cam2.make_current()
			$AnimationPlayer.play("middle_heaven")
		
		await get_tree().create_timer(7.0).timeout
		if MiscManager.chapter3_no_death:
			MiscManager.end_no_death()
			AchievementManager.unlock("lost_hell_no_death_run")
		AchievementManager.unlock("lost_hell_complete")
		SaveManager.unlock_level("the_hell", 36)
		SaveManager.unlock_chapter("the_deep_hell, 3")
		LoadingManager.goto("res://Scenes/endCredits.tscn")
