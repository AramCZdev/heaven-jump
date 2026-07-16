extends Node

@onready var admob: Admob = $Admob

var levels_completed := 0


func _ready() -> void:
	print("AdManager ready, initializing...")
	admob.initialize()
	await admob.initialization_completed
	print("AdMob is ready! Preloading first ad.")
	
	admob.load_interstitial_ad()


func level_completed() -> void:
	levels_completed += 1
	print("Levels completed: ", levels_completed)

	if levels_completed % 5 == 0:
		print("5 levels reached, showing ad")
		admob.show_interstitial_ad()
		admob.load_interstitial_ad()
