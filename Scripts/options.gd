extends Control  # or Control, or whatever node you want to hover

@export var hover_distance := 10.0
@export var hover_time := 1.0

func _ready():
	await get_tree().create_timer(2.3).timeout
	start_hover()

func start_hover():
	var tween = create_tween()
	tween.set_loops()  # loops forever
	tween.tween_property(self, "position:y", position.y - hover_distance, hover_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", position.y, hover_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
