extends Control

@export var next_scene_path: String
var has_started := false  # ✅ Declare this to fix the error

func _ready():
	print("[LoadingScreen] Showing loading screen...")

	# Optionally update next_scene_path from GameManager (if used)
	if GameManager.has_method("get_target_scene_path"):
		next_scene_path = GameManager.target_scene_path

func _process(_delta: float) -> void:
	if not has_started and next_scene_path != "":
		has_started = true
		show_loading_and_load_scene()

func show_loading_and_load_scene() -> void:
	print("[LoadingScreen] Showing loading screen...")
	$Label.text = "Loading..."

	await get_tree().create_timer(3.0).timeout
	print("[LoadingScreen] Done waiting, loading:", next_scene_path)

	var next_scene = load(next_scene_path)
	if next_scene is PackedScene:
		get_tree().change_scene_to_packed(next_scene)
	else:
		push_error("[LoadingScreen] ❌ Invalid scene path: %s" % next_scene_path)
