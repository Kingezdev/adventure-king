extends Control

@onready var button: Button = $Button


func _on_Button_pressed():
	LoadingManager.load_scene_with_loading("res://Game_UI.tscn")
