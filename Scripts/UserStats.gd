extends Node

@export var max_mana: int = 100
var current_mana: int = max_mana
var mana_bar: ProgressBar = null

@export var max_health: int = 100
var current_health: int = max_health
var health_bar: ProgressBar = null  # UI reference

func _ready():
	print("[UserStats] ✅ Ready - Max HP:", max_health, "| Max Mana:", max_mana)

# --- Automatically link UI elements for any scene ---
func connect_scene_ui(scene: Node) -> void:
	health_bar = scene.find_child("health_bar", true, false)
	mana_bar = scene.find_child("mana_bar", true, false)

	update_health_bar()
	update_mana_bar()

	if health_bar:
		print("[UserStats] ✅ Health bar linked:", health_bar.name)
	else:
		print("[UserStats] ⚠ Health bar NOT found in new scene")

	if mana_bar:
		print("[UserStats] ✅ Mana bar linked:", mana_bar.name)
	else:
		print("[UserStats] ⚠ Mana bar NOT found in new scene")

# --- Optional manual setters ---
func set_health_bar(bar: ProgressBar) -> void:
	health_bar = bar
	update_health_bar()
	print("[UserStats] ✅ Health bar set:", bar)

func set_mana_bar(bar: ProgressBar) -> void:
	mana_bar = bar
	mana_bar.max_value = max_mana
	mana_bar.value = current_mana
	print("[UserStats] ✅ Mana bar set:", bar)

# --- Health and Mana Operations ---
func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	print("[UserStats] ❌ Took damage:", amount, "| New HP:", current_health)

	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("start_shake"):
		camera.start_shake(0.2, 6)

	update_health_bar()

	# 🔴 Check if player is dead
	if current_health <= 0:
		print("[UserStats] Player died - loading Game Over screen")
		var game_over_scene = load("res://Scenes/game_over.tscn")
		get_tree().change_scene_to_packed(game_over_scene)

	

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	print("[UserStats] 💚 Healed:", amount, "| New HP:", current_health)
	update_health_bar()

func update_health_bar() -> void:
	if health_bar:
		health_bar.value = current_health
		print("[UserStats] 🔁 Updated health bar:", current_health)
	else:
		print("[UserStats] ⚠ Health bar not assigned.")

func update_mana_bar() -> void:
	if mana_bar:
		mana_bar.max_value = max_mana
		mana_bar.value = current_mana
		print("[UserStats] 🔁 Updated mana bar:", current_mana)
	else:
		print("[UserStats] ⚠ Mana bar not assigned.")

# --- Mana usage ---
func use_mana(amount: int) -> bool:
	if not mana_bar:
		print("[UserStats] ⚠ Mana bar not linked yet!")

	if current_mana >= amount:
		current_mana -= amount
		if mana_bar:
			mana_bar.value = current_mana
		print("[UserStats] ✅ Used", amount, "mana | Remaining:", current_mana, "/", max_mana)
		return true
	else:
		print("[UserStats] ❌ Not enough mana! Required:", amount, " | Current:", current_mana)
		return false
