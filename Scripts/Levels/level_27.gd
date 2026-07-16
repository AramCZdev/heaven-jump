extends Node2D

@onready var Vent: ColorRect = $ColorRect
@onready var music: AudioStreamPlayer2D = $"Red cube/BreakIn"
@onready var breakwindows: AudioStreamPlayer2D = $"Red cube/SfxHurt"
@onready var orb: Area2D = $JumpOrb
@onready var buttonicol: CollisionShape2D = $Button/CollisionShape2D

func _ready() -> void:
	Vent.visible = true


func _on_hidev_body_entered(_body: Node2D) -> void:
	Vent.visible = false
	breakwindows.play()
	music.play()


func _on_button_body_entered(_body: Node2D) -> void:
	orb.move_local_y(820)
	buttonicol.move_local_y(-10000)
