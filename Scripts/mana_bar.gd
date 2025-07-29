# ManaBar.gd
extends ProgressBar

@export var max_mana := 100
var current_mana := max_mana

func _ready():
	max_value = max_mana
	value = current_mana
	update_mana_bar()

func use_mana(amount: int) -> bool:
	if current_mana >= amount:
		current_mana -= amount
		update_mana_bar()
		return true
	else:
		print("[ManaBar] ❌ Not enough mana:", current_mana, "needed:", amount)
		return false

func refill_mana(amount: int):
	current_mana = min(current_mana + amount, max_mana)
	update_mana_bar()

func set_mana(amount: int):
	current_mana = clamp(amount, 0, max_mana)
	update_mana_bar()

func update_mana_bar():
	value = current_mana
