extends CanvasLayer

@onready var rect: ColorRect = $ColorRect
var tween: Tween

func _ready() -> void:
	rect.color = Color(0, 0, 0, 0)  # start fully transparent
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  # ✅ let clicks pass through
	print("[FadeTransition] Ready - starting transparent")

func fade_to_scene(scene_path: String, duration: float = 1.0) -> void:
	print("[FadeTransition] fade_to_scene called - scene:", scene_path, "duration:", duration)

	# Kill any existing tween
	if tween:
		print("[FadeTransition] Killing existing tween")
		tween.kill()

	# Fade to black
	print("[FadeTransition] Starting fade to black")
	tween = get_tree().create_tween()
	tween.tween_property(rect, "color:a", 1.0, duration)
	tween.tween_callback(Callable(self, "_change_scene").bind(scene_path))

func _change_scene(scene_path: String) -> void:
	print("[FadeTransition] Changing scene to:", scene_path)
	get_tree().change_scene_to_file(scene_path)

	# Fade back in after scene loads
	if tween:
		print("[FadeTransition] Killing tween before fade-in")
		tween.kill()
	print("[FadeTransition] Starting fade back in")
	tween = get_tree().create_tween()
	tween.tween_property(rect, "color:a", 0.0, 0.8)
