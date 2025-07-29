extends Node2D  # or Control, if you're using Control

var connections = []  # Array of [Vector2, Vector2] pairs

func set_connections(new_connections):
	connections = new_connections
	print(self)
	  # Valid on Node2D or Control

func _draw():
	for pair in connections:
		draw_line(pair[0], pair[1], Color.WHITE, 2)
