extends Node2D

@onready var lock: StaticBody2D = $Lock
@onready var key: Area2D = $Key
@onready var lock2: StaticBody2D = $Lock2
@onready var key2: Area2D = $Key2
@onready var lock3: CollisionShape2D = $Spike4/CollisionSpike2
@onready var key3: Area2D = $Key3
@onready var lock4: StaticBody2D = $Platform43
@onready var key4: Area2D = $Platform42/Key4
@onready var destination: Marker2D = $Marker2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var player = $"Red cube"
@onready var anim = $AnimationPlayer.get_animation("spikes_danger")
@onready var lock5: StaticBody2D = $Lock3
@onready var key5: Area2D = $Key4

func _on_key_body_entered(_body: Node2D) -> void:
	lock.global_position = destination.global_position   
	key.global_position = destination.global_position   


func _on_key_2_body_entered(_body: Node2D) -> void:
	lock2.global_position = destination.global_position   
	key2.global_position = destination.global_position


func _on_start_anim_body_entered(_body: Node2D) -> void:
	animation.play("move_up")


func _on_key_3_body_entered(_body: Node2D) -> void:
	lock3.global_position = destination.global_position   
	key3.global_position = destination.global_position


func _on_start_anim_2_body_entered(_body: Node2D) -> void:
	animation.play("tatmovingpart")


func _on_activate_trap_body_entered(_body: Node2D) -> void:
	anim.loop_mode = Animation.LOOP_LINEAR
	animation.play("spikes_danger")


func _on_key_4_body_entered(_body: Node2D) -> void:
	if _body is CharacterBody2D:
		lock4.global_position = destination.global_position
		key4.global_position = destination.global_position


func _on_key_5_body_entered(_body: Node2D) -> void:
	if _body is CharacterBody2D:
		lock5.global_position = destination.global_position
		key5.global_position = destination.global_position
