extends Control

@export var scene_to_load: String = "res://Scenes/main_menu.tscn"
@export var min_intro_time: float = 5.0  # You can adjust this to whatever you like

var _loading := false
var _elapsed_time := 0.0
var _scene_ready := false
var _loaded_scene: PackedScene = null

@onready var status_label: Label = $ProgressContainer/StatusLabel
@onready var progress_bar: ProgressBar = $ProgressContainer/ProgressBar
@onready var intro_sprite: AnimatedSprite2D = $IntroSprite

func _ready() -> void:
	print("🔵 [Loader] _ready() called")
	status_label.text = "Preparing to load..."
	progress_bar.value = 0.0
	_start_intro_and_load()
	set_process(true)

func _process(delta: float) -> void:
	if not _loading:
		return

	_elapsed_time += delta
	var time_ratio: float = clamp(_elapsed_time / min_intro_time, 0.0, 1.0)
	progress_bar.value = time_ratio * 100.0

	if _scene_ready and time_ratio >= 1.0:
		print("✅ [Loader] Time and load complete. Activating scene.")
		_loading = false
		_activate_scene(_loaded_scene)

	var status := ResourceLoader.load_threaded_get_status(scene_to_load)
	match status:
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
			status_label.text = "Loading..."
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			if not _scene_ready:
				_loaded_scene = ResourceLoader.load_threaded_get(scene_to_load)
				_scene_ready = true
				print("✅ [Loader] Scene loaded, waiting for timer...")

		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			status_label.text = "❌ Failed to load scene"
			print("❌ [Loader] Scene failed to load!")
			push_error("❌ Scene failed to load!")
			_loading = false

func _start_intro_and_load() -> void:
	print("🔵 [Loader] Starting intro animation and loading")
	_elapsed_time = 0.0
	_scene_ready = false
	_loading = true
	intro_sprite.play()

	var err := ResourceLoader.load_threaded_request(scene_to_load)
	if err != OK:
		status_label.text = "Threaded load request failed"
		print("❌ [Loader] Threaded request failed with error code: %s" % err)
		push_error("❌ Threaded load request failed with error: %s" % err)
		_loading = false
	else:
		print("✅ [Loader] Threaded request issued successfully for scene: %s" % scene_to_load)

func _activate_scene(scene: PackedScene) -> void:
	status_label.text = "Switching scenes..."
	print("🚀 [Loader] Changing to new scene: %s" % scene_to_load)
	get_tree().change_scene_to_packed(scene)
