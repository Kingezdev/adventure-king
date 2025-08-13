extends Button
var Stage_1 = preload("res://Scenes/stage_1_game.tscn")
@export var level_scene_path: String  # Path to the level scene (e.g., "res://levels/Level1.tscn")

func _ready():
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(Stage_1)
