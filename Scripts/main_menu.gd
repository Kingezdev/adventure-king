extends Node2D

func _ready():
	$MenuAnimation.play("Adventure")
	$MenuAnimation.animation_finished.connect(_on_entrance_finished)

func _on_entrance_finished(anim_name: String):
	if anim_name == "Adventure":
		for comp in get_tree().get_nodes_in_group("hover_components"):
			comp.start_hover()
