extends Control
@onready var health_bar: ProgressBar = $PlayerStats/Health_bar
@onready var player_stats = $PlayerStats
@onready var mana_bar: ProgressBar = $PlayerStats/mana_bar


func _ready():
	UserStats.set_mana_bar(mana_bar)
	UserStats.set_health_bar(health_bar)
	print("[Game_UI] ✅ Ready")
	if health_bar:
		GameManager.health_bar = health_bar
		print("[Game_UI] ✅ Assigned health_bar to GameManager:", health_bar)
	else:
		push_error("[Game_UI] ❌ Health_bar not found!")
	for child in player_stats.get_children():
		print("[Debug] Child of PlayerStats:", child.name)
