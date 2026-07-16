extends Area2D

@onready var Destination = $Marker2D

func _ready():
	connect("body_entered", _on_portal_body_entered)

func _on_portal_body_entered(body):
	if body is CharacterBody2D:
		body.global_position = Destination.global_position   
