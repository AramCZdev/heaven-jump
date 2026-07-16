extends CanvasLayer

@onready var right: TouchScreenButton = $Left/Right
@onready var left: TouchScreenButton = $Left/Left
@onready var jump: TouchScreenButton = $Right/Jump
@onready var dash: TouchScreenButton = $Right/Dash
@onready var pause: TouchScreenButton = $TopRight/Pause

func _ready() -> void:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		right.visible = true
		left.visible = true
		jump.visible = true
		dash.visible = true
		pause.visible = true
	else:
		right.visible = false
		left.visible = false
		jump.visible = false
		dash.visible = false
		pause.visible = false

func _on_right_pressed() -> void:
	right.modulate.a = 0.5


func _on_right_released() -> void:
	right.modulate.a = 1.0


func _on_left_pressed() -> void:
	left.modulate.a = 0.5


func _on_left_released() -> void:
	left.modulate.a = 1.0


func _on_jump_pressed() -> void:
	jump.modulate.a = 0.5


func _on_jump_released() -> void:
	jump.modulate.a = 1.0


func _on_dash_pressed() -> void:
	dash.modulate.a = 0.5


func _on_dash_released() -> void:
	dash.modulate.a = 1.0
