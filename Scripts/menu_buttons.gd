extends Control

var deck: HBoxContainer = null
@onready var adventure: Button = $Adventure

func _ready():
	adventure.pressed.connect(_on_adventure_pressed)
	

func _on_adventure_pressed():
	# Get current scene root
	LoadingManager.load_scene_with_loading("res://Game_UI.tscn")

	var current_scene = get_tree().get_current_scene()
	

# Print the scene's node name
	

	# This replaces the current scene (MainMenu) with Game_UI
	get_tree().change_scene_to_file("res://Scenes/game_ui.tscn")
	
	print("Current scene name: ", current_scene.name)

# Or print full node path of the root scene
	print("Current scene path: ", current_scene.get_path())

	print("Adventure button pressed, loading game scene...")
