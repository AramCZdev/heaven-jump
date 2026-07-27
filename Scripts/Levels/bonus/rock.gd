extends Node2D

@export var note_speed := 300.0
@export var spawn_distance := 600.0

var score := 0
var combo := 0
var song_time := 0.0

var notes = [
	{"time": 1.0, "direction": "left"},
	{"time": 1.5, "direction": "up"},
	{"time": 2.0, "direction": "right"},
	{"time": 2.5, "direction": "down"},
	{"time": 3.0, "direction": "left"},
	{"time": 3.5, "direction": "right"},
	{"time": 4.0, "direction": "left"},
	{"time": 4.5, "direction": "up"},
	{"time": 5.0, "direction": "right"},
	{"time": 5.5, "direction": "down"},
	{"time": 6.0, "direction": "left"},
	{"time": 7.5, "direction": "right"},
	{"time": 8.0, "direction": "left"},
	{"time": 8.5, "direction": "up"},
	{"time": 9.0, "direction": "right"},
	{"time": 9.5, "direction": "down"},
	{"time": 10.0, "direction": "left"},
	{"time": 10.5, "direction": "right"},
	{"time": 11.0, "direction": "left"},
	{"time": 11.5, "direction": "down"},
	{"time": 12.0, "direction": "up"},
	{"time": 12.5, "direction": "right"},
]

var spawned_notes = []

@onready var hit_zone = $HitZone
@onready var score_label = $CanvasLayer/ScoreLabel

func _ready() -> void:
	score_label.text = "Score: 0"

func spawn_note(direction):
	var note = Sprite2D.new()
	note.texture = preload("res://Photos/Nav/Next.png")

	match direction:
		"up":
			note.rotation_degrees = -90
		"right":
			note.rotation_degrees = 0
		"down":
			note.rotation_degrees = 90
		"left":
			note.rotation_degrees = 180

	note.set_meta("direction", direction)
	note.position = get_spawn_position(direction)

	add_child(note)
	spawned_notes.append(note)


func get_spawn_position(direction):
	match direction:
		"left":
			return Vector2(350, -spawn_distance)
		"down":
			return Vector2(450, -spawn_distance)
		"up":
			return Vector2(550, -spawn_distance)
		"right":
			return Vector2(650, -spawn_distance)
	
	return Vector2.ZERO


func move_notes(delta):
	for note in spawned_notes.duplicate():
		if is_instance_valid(note):
			note.position.y += note_speed * delta
			
			if note.position.y > hit_zone.position.y + 100:
				$HitSound.play()
				combo = 0
				score = max(score - 100, 0)
				score_label.text = "Score: " + str(score)

				note.queue_free()
				spawned_notes.erase(note)


func _input(event):
	if event.is_action_pressed("ui_left"):
		check_hit("left")

	elif event.is_action_pressed("ui_down"):
		check_hit("down")

	elif event.is_action_pressed("ui_up"):
		check_hit("up")

	elif event.is_action_pressed("ui_right"):
		check_hit("right")

func _process(delta):
	song_time += delta

	for note_data in notes:
		if note_data.time <= song_time and not note_data.has("spawned"):
			print("Spawning:", note_data.direction)
			spawn_note(note_data.direction)
			note_data.spawned = true

	move_notes(delta)

func check_hit(direction):
	print("Pressed:", direction)

	var closest_note = null
	var closest_distance = 99999
	
	for note in spawned_notes:
		if is_instance_valid(note):
			if note.get_meta("direction") == direction:
				var distance = abs(note.position.y - hit_zone.position.y)
				print("Distance:", distance)
				
				if distance < closest_distance:
					closest_distance = distance
					closest_note = note
	
	if closest_note and closest_distance < 40:
		print("GOOD HIT")
		score += 100
		score_label.text = "Score: " + str(score)
		
		closest_note.queue_free()
		spawned_notes.erase(closest_note)


func _on_audio_stream_player_2d_finished() -> void:
	SaveManager.unlock_secret("the_hell", "rock")
	LoadingManager.goto("res://Scenes/BonusLevels.tscn")
	AdManager.level_completed()
