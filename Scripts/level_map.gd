extends Control
var Stage_1 = preload("res://Scenes/stage_1_game.tscn")

func _on_stage_1_pressed() -> void:
	get_tree().change_scene_to_packed(Stage_1)
