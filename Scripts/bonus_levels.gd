extends Control

var codes = {
	"HELLJUMPBETA": "res://Scenes/Bonus/Level1.tscn",
	"THISSUCKS": "res://Scenes/Bonus/Level2.tscn",
	"FALL": "res://Scenes/Bonus/Sky.tscn",
	"MONEYHUNGRY": "res://Scenes/Bonus/$.tscn",
	"HELLJUMP3D": "res://Scenes/Bonus/Level3D.tscn"
}

func _ready() -> void:
	$More2.visible = false
	$Code/INCORRECT_BUTTON.visible = false
	if SaveManager.is_secret_unlocked("the_hell", "beta1"):
		$Control/B1.visible = true
	else:
		$Control/B1.visible = false
		
	if SaveManager.is_secret_unlocked("the_hell", "beta2"):
		$Control/B2.visible = true
	else:
		$Control/B2.visible = false

	if SaveManager.is_secret_unlocked("the_hell", "sky"):
		$Control/sky.visible = true
	else:
		$Control/sky.visible = false

	if SaveManager.is_secret_unlocked("the_hell", "$"):
		$"Control/$".visible = true
	else:
		$"Control/$".visible = false
	if SaveManager.is_secret_unlocked("the_hell", "3D"):
		$"Control/3D".visible = true
	else:
		$"Control/3D".visible = false



func _on_submit_button_pressed() -> void:
	var code = $Code/LineEdit.text.strip_edges().to_upper()

	if codes.has(code):
		LoadingManager.goto(codes[code])
	else:
		$"Code/Submit Button".visible = false
		$Code/INCORRECT_BUTTON.visible = true
		
		await get_tree().create_timer(2).timeout
		
		$"Code/Submit Button".visible = true
		$Code/INCORRECT_BUTTON.visible = false


func _on_b_1_pressed() -> void:
	LoadingManager.goto("res://Scenes/Bonus/Level1.tscn")


func _on_b_2_pressed() -> void:
	LoadingManager.goto("res://Scenes/Bonus/Level2.tscn")


func _on_sky_pressed() -> void:
	LoadingManager.goto("res://Scenes/Bonus/Sky.tscn")


func _on_more_pressed() -> void:
	$More2.visible = true


func _on_ok_pressed() -> void:
	$More2.visible = false


func _on_back_button_pressed() -> void:
	LoadingManager.goto("res://Scenes/MainMenu.tscn")


func _on_money_pressed() -> void:
	LoadingManager.goto("res://Scenes/Bonus/$.tscn")


func _on_threed_pressed() -> void:
	LoadingManager.goto("res://Scenes/Bonus/Level3D.tscn")
