extends Node2D

func _ready():
	print("[DEBUG] Stage 1 game started")
	DialogueManager.start_dialogue_from_file(
		"res://data/dialogues/stage_1.json",
		_on_dialogue_finished
	)

func _on_dialogue_finished():
	print("[DEBUG] Dialogue finished, continue game...")
	start_gameplay()

func start_gameplay():
	print("[DEBUG] Gameplay started for Stage 1")
	# TODO: Enable player controls, spawn enemies, etc.

func end_gameplay():
	print("[DEBUG] Gameplay ended. Loading next stage...")
	get_tree().change_scene_to_file("res://scenes/stage_2.tscn")
