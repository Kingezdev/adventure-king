extends Node

@export var max_mana : int = 100
var current_mana : int= max_mana

var mana_bar: ProgressBar

var max_health: int = 100
var current_health: int = max_health

var health_bar: ProgressBar = null  # UI reference (optional)

func _ready():
	print("[UserStats] ✅ Ready - Max HP:", max_health)

func set_health_bar(bar: ProgressBar) -> void:
	health_bar = bar
	update_health_bar()
	print("[UserStats] ✅ Health bar set:", bar)
	
func set_mana_bar(bar: ProgressBar) -> void:
	mana_bar = bar
	mana_bar.max_value = max_mana
	mana_bar.value = current_mana
	print("[UserStats] ✅ Mana bar set:", bar)

func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	print("[UserStats] ❌ Took damage:", amount, "| New HP:", current_health)
	# Camera shake on damage
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("start_shake"):
		camera.start_shake(0.2, 6)  # shake_duration, shake_intensity
	update_health_bar()

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
		
func use_mana(amount: int) -> bool:
	if current_mana >= amount:
		current_mana -= amount
		print("[UserStats] ✅ Used", amount, "mana | Remaining:", current_mana, "/", max_mana)

		if mana_bar:
			mana_bar.value = current_mana
		else:
			print("[UserStats] ⚠ Mana bar not set!")

		return true
	else:
		print("[UserStats] ❌ Not enough mana! Required:", amount, " | Current:", current_mana)
		return false
