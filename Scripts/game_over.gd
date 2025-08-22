extends Node2D  # or CanvasLayer if preferred

@onready var rect: TextureRect = $TextureRect
var tween: Tween

func _ready() -> void:
	# Start fully transparent
	modulate.a = 0.0

	# Fade in the entire container
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.5)  # 1.5s fade-in
	print("[GameOver] Fading in entire UI...")

	# Handle viewport resizing
	get_viewport().size_changed.connect(_on_resized)

func _on_resized() -> void:
	rect.size = get_viewport_rect().size
