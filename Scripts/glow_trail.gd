extends Node2D

var connections: Array = []

func set_connections(new_connections: Array):
	connections = new_connections
	queue_redraw()  # ✅ Godot 4 version of `update()`

func _draw():
	for pair in connections:
		draw_line(pair[0], pair[1], Color.CYAN, 2)  # ✅ Use Color.CYAN (uppercase)
