extends Node2D

@onready var lock: StaticBody2D = $Platform39
@onready var key: Area2D = $Key
@onready var lock2: StaticBody2D = $Platform40
@onready var key2: Area2D = $Key2
@onready var lock3: StaticBody2D = $Platform41
@onready var key3: Area2D = $Key3
@onready var lock4: StaticBody2D = $Platform42
@onready var key4: Area2D = $Key4
@onready var destination: Marker2D = $Marker2D

func _on_key_body_entered(_body: Node2D) -> void:
	lock.global_position = destination.global_position  
	key.global_position = destination.global_position   


func _on_key_2_body_entered(_body: Node2D) -> void:
	lock2.global_position = destination.global_position  
	key2.global_position = destination.global_position   


func _on_key_3_body_entered(_body: Node2D) -> void:
	lock3.global_position = destination.global_position  
	key3.global_position = destination.global_position   


func _on_key_4_body_entered(_body: Node2D) -> void:
	lock4.global_position = destination.global_position  
	key4.global_position = destination.global_position  


func _on_finish_line_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_restart_pressed() -> void:
	pass # Replace with function body.
