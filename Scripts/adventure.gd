extends Control  # or Control, or whatever node you want to hover
var level_map = preload("res://Scenes/level_map.tscn")
@export var hover_distance := 10.0
@export var hover_time := 1.0

func _ready():
	start_hover()

func start_hover():
	var tween = create_tween()
	tween.set_loops()  # loops forever
	tween.tween_property(self, "position:y", position.y - hover_distance, hover_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", position.y, hover_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(level_map)
	
