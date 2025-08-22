extends Node2D
@onready var health_bar: ProgressBar = $PlayerStats/Health_bar
@onready var player_stats = $PlayerStats
@onready var mana_bar: ProgressBar = $PlayerStats/mana_bar
var tween: Tween

func _ready():
	# Start fully transparent
	modulate.a = 0.0

	# Fade in the entire container
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.5)  # 1.5s fade-in
	print("[GameOver] Fading in entire UI...")
	
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
	
