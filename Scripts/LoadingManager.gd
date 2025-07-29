extends Node

func load_scene_with_loading(next_scene_path: String) -> void:
	print("[LoadingManager] Loading requested for:", next_scene_path)
	GameManager.target_scene_path = next_scene_path
	get_tree().change_scene_to_file("res://loading_screen.tscn")
