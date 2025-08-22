extends Control

# Custom class reference
var alive_enemies: Array = []
var has_enemies_in_scene: bool = false
const SAVE_FILE_PATH := "user://autosave.save"
@onready var save_timer := Timer.new()

var selected_card: Control = null
var mouse_over_monster: Node = null
var health_bar: ProgressBar = null

@onready var deck: HBoxContainer = null
var discard_pile: Array[Control] = []
var is_player_turn := true
var target_scene_path: String = ""



func _ready() -> void:
	 # When the scene changes, scan once to see if there are enemies

	
	print("[PlayerStats] _ready() called - instance id:", self.get_instance_id())
	print("[GameManager] _ready() called")
	LoadingManager.load_scene_with_loading("res://Game_UI.tscn")
	print("[GameManager] Requested Game_UI scene load")

	get_tree().connect("scene_changed", Callable(self, "_on_scene_changed"))

	deck = get_deck()
	if deck:
		print("[GameManager] Initial deck found:", deck.name)
		start_player_turn()
	else:
		print("[GameManager] Initial deck NOT found!")

	var current_scene = get_tree().get_current_scene()
	if current_scene:
		print("[GameManager] Current scene root:", current_scene.name)
		print("[GameManager] Current scene path:", current_scene.get_path())
	else:
		print("[GameManager] WARNING: No current scene found at _ready()")

	# Try to find PlayerStats immediately
	health_bar = current_scene.find_child("health_bar", true, false) if current_scene else null
	if health_bar:
		print("[GameManager] ✅ health_bar found at _ready():", health_bar.name)
	else:
		print("[GameManager] ❌ health_bar NOT found at _ready()")

func check_player_won() -> void:
	var scene := get_tree().get_current_scene()
	if scene == null:
		return

	# Collect all *alive* enemies recursively
	var alive_enemies: Array = []
	_collect_alive_enemies(scene, alive_enemies)

	print("[GameManager] Alive enemies found:", alive_enemies.size())

	if alive_enemies.is_empty():
		print("[GameManager] ✅ Player won! No enemies left.")
		get_tree().change_scene_to_file("res://scenes/you_won.tscn")


# Recursive helper to collect only alive enemies
func _collect_alive_enemies(node: Node, enemies: Array) -> void:
	if node.is_in_group("Enemies") and is_instance_valid(node):
		# Prefer a proper method on enemies
		if node.has_method("is_alive"):
			if node.is_alive():
				enemies.append(node)
		# Otherwise fall back to checking hp property directly
		elif "hp" in node:  # <-- FIX: safe property existence check
			if node.hp > 0:
				enemies.append(node)

	for child in node.get_children():
		_collect_alive_enemies(child, enemies)




func _debug_print_tree(node: Node, indent: int = 0) -> void:
	var prefix = "  ".repeat(indent)
	print(prefix + "- " + node.name + " (" + node.get_class() + ")")

	for child in node.get_children():
		_debug_print_tree(child, indent + 1)


func change_scene_with_loading(scene_path: String):
	var loading_scene = preload("res://Scenes/loading_screen.tscn").instantiate()
	loading_scene.next_scene_path = scene_path
	get_tree().root.add_child(loading_scene)


func _on_scene_changed(new_scene: Node) -> void:
	UserStats.connect_scene_ui(new_scene)
	print("[GameManager] Scene changed to:", new_scene.name if new_scene else "null")

	if not new_scene:
		print("[GameManager] WARNING: new_scene is null in _on_scene_changed!")
		return

	await get_tree().process_frame

	print("[GameManager] Printing node tree for new scene:")
	_debug_print_tree(new_scene)

	call_deferred("_resolve_player_stats", new_scene)

	health_bar = new_scene.find_child("health_bar", true, false)
	if health_bar:
		print("[GameManager] ✅ health_bar found immediately in new scene:", health_bar.name)
	else:
		print("[GameManager] ❌ health_bar NOT found immediately in new scene")

	if new_scene.has_node("Deck"):
		deck = new_scene.get_node("Deck") as HBoxContainer
		print("[GameManager] Deck found on scene change:", deck.name)
		start_player_turn()
	else:
		deck = null
		discard_pile.clear()
		print("[GameManager] Deck NOT found on scene change, discard pile cleared.")


func _resolve_player_stats(scene: Node) -> void:
	print("[GameManager][_resolve_player_stats] Called with scene:", scene.name)
	health_bar = scene.find_child("health_bar", true, false)
	if health_bar:
		print("[GameManager][_resolve_player_stats] ✅ health_bar found (deferred):", health_bar.name)
		update_enemies_with_playerstats()
	else:
		print("[GameManager][_resolve_player_stats] ❌ health_bar NOT found (deferred)")


func get_deck() -> HBoxContainer:
	var current_scene = get_tree().get_current_scene()
	if current_scene:
		print("[get_deck] Current scene:", current_scene.name)
	else:
		print("[get_deck] WARNING: No current scene found")
	if current_scene and current_scene.has_node("Deck"):
		var d = current_scene.get_node("Deck") as HBoxContainer
		print("[get_deck] Deck found:", d.name)
		return d
	print("[get_deck] Deck NOT found in current scene.")
	return null


func shuffle_deck() -> void:
	if deck == null:
		print("[shuffle_deck] ERROR: Deck node missing!")
		return

	var cards := deck.get_children()
	print("[shuffle_deck] Total cards before shuffle:", cards.size())

	for card in cards:
		deck.remove_child(card)

	cards.shuffle()

	for card in cards:
		if card is CanvasItem:
			card.scale = Vector2.ONE
			card.visible = true
			card.position = Vector2.ZERO
		deck.add_child(card)

	print("[shuffle_deck] ✅ Deck shuffled and cards re-added.")


func reshuffle_discard_into_deck() -> void:
	if discard_pile.is_empty():
		print("[reshuffle_discard_into_deck] No cards to reshuffle.")
		return

	print("[reshuffle_discard_into_deck] Reshuffling %d discarded cards back into deck..." % discard_pile.size())
	discard_pile.shuffle()

	for card in discard_pile:
		if deck == null:
			push_error("[reshuffle_discard_into_deck] ERROR: Deck is null before adding cards!")
			return
		deck.add_child(card)
		card.visible = true
		card.position = Vector2.ZERO
		card.scale = Vector2.ONE

	discard_pile.clear()
	print("[reshuffle_discard_into_deck] Reshuffle complete. Deck size now: %d" % deck.get_child_count())


func start_player_turn():
	print("[start_player_turn] ▶ Starting player turn")
	var current_scene = get_tree().get_current_scene()
	if current_scene:
		print("[Scene Debug] Current scene name: %s" % current_scene.name)
	else:
		print("[Scene Debug] ❌ No current scene loaded!")

	var scene_root = get_tree().get_current_scene()
	if scene_root and scene_root.has_node("Deck"):
		deck = scene_root.get_node("Deck")
		print("[start_player_turn] ✅ Deck refreshed from scene.")
	else:
		print("[start_player_turn] ❌ Could not find deck node in scene.")
		return

	if not deck:
		print("[start_player_turn] ❌ Deck is NULL after refresh.")
		return

	print("[start_player_turn] 🔁 Moving discard pile back to deck...")
	for card in discard_pile:
		deck.add_child(card)
	discard_pile.clear()

	print("[start_player_turn] 🔀 Shuffling deck...")
	shuffle_deck()


func enemies_attack() -> void:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if enemy.has_method("reset_scale"):
			enemy.reset_scale()

	print("[enemies_attack] %d enemies found." % enemies.size())

	for enemy in enemies:
		if enemy:
			if enemy.has_method("play_attack_animation"):
				print("[enemies_attack] Calling play_attack_animation for:", enemy.name)
				enemy.play_attack_animation()
			else:
				print("[enemies_attack] ⚠ Enemy %s missing play_attack_animation!" % enemy.name)

			if enemy.has_method("perform_attack"):
				print("[enemies_attack] Calling perform_attack for:", enemy.name)
				print("[Enemy] About to call take_damage on health_bar:", health_bar)
				await enemy.perform_attack()
			else:
				print("[enemies_attack] ⚠ Enemy %s missing perform_attack!" % enemy.name)

	print("[enemies_attack] ✅ Enemies finished attacking.")
	start_player_turn()
	print("players turn has started")


func select_card(card: Control) -> void:
	if selected_card == card:
		if selected_card.has_method("set_selected"):
			selected_card.set_selected(false)
		selected_card = null
		print("[select_card] Deselected card.")
		_notify_enemies_card_selected(false)
		return

	if selected_card and selected_card.has_method("set_selected"):
		selected_card.set_selected(false)

	selected_card = card

	if selected_card and selected_card.has_method("set_selected"):
		selected_card.set_selected(true)
		print("[select_card] Selected card:", selected_card.name)
		_notify_enemies_card_selected(true)


func use_selected_card_on(monster: Node) -> void:
	if not selected_card:
		print("[use_selected_card_on] ❌ No card selected.")
		return

	if not monster:
		print("[use_selected_card_on] ❌ No monster selected.")
		return

	if not selected_card.is_inside_tree():
		print("[use_selected_card_on] ❌ Card not in tree. Discarded or already used.")
		selected_card = null
		return
	print("[use_selected_card_on] Attempting to use selected card on:", monster.name if monster else "null")

	if selected_card and selected_card.is_inside_tree() and monster:
		var damage := 0
		var mana_cost := 2  # Default cost

		# Get damage from card
		if selected_card.has_method("get_damage"):
			damage = selected_card.get_damage()
		else:
			push_warning("[use_selected_card_on] Card missing get_damage(), defaulting to 10 damage.")
			damage = 10
		# Apply healing if card has it
		if selected_card.has_method("get_heal") and selected_card.get_heal() > 0:
			UserStats.heal(selected_card.get_heal())
			print("[Card] Healing player for %d" % selected_card.get_heal())
		
		# Safely try to get mana_cost property from the card script
		if "mana_cost" in selected_card:
			mana_cost = selected_card.mana_cost
		else:
			print("[use_selected_card_on] Card has no mana_cost variable, using default 2.")

		# Check if enough mana
		if not UserStats.mana_bar.use_mana(mana_cost):
			print("[use_selected_card_on] ❌ Not enough mana to use card (cost: %d)" % mana_cost)
			return

		print("[use_selected_card_on] ✅ Enough mana. Dealing %d damage to %s" % [damage, monster.name])

		# Deal damage to monster
		if monster.has_method("take_damage"):
			monster.take_damage(damage)
		else:
			push_warning("[use_selected_card_on] Monster %s missing take_damage()!" % monster.name)

		# Discard card
		if selected_card.get_parent():
			selected_card.get_parent().remove_child(selected_card)
			selected_card.visible = false
			discard_pile.append(selected_card)
			print("[use_selected_card_on] Card moved to discard pile:", selected_card.name)
	
		selected_card = null
		mouse_over_monster = null
	else:
		print("[use_selected_card_on] Either card or monster is invalid.")



func _notify_enemies_card_selected(is_selected: bool) -> void:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if is_selected and enemy.has_method("on_card_selected"):
			enemy.on_card_selected()
		elif enemy.has_method("on_card_deselected"):
			enemy.on_card_deselected()


func update_enemies_with_playerstats():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if enemy.has_method("set_player_stats"):
			enemy.set_player_stats(health_bar)
			

func player_won() -> void:
	print("[GameManager] 🔍 Checking if player won...")

	# Get all enemies in the "Enemies" group
	var all_enemies = get_tree().get_nodes_in_group("Enemies")
	print("[GameManager] Total enemies in group:", all_enemies.size())

	var scene = get_tree().get_current_scene()
	print("[GameManager] Current scene:", scene.name)

	# Filter only enemies that belong to the current scene
	var enemies: Array = []
	for e in all_enemies:
		if is_instance_valid(e):
			print(" - Found enemy:", e.name, "| Valid:", is_instance_valid(e), "| In current scene:", scene.is_ancestor_of(e))
			if scene.is_ancestor_of(e):
				enemies.append(e)

	print("[GameManager] Enemies still in scene:", enemies.size())

	if enemies.size() == 0:
		print("[GameManager] ✅ Player won! No enemies left.")
		get_tree().change_scene("res://scenes/you_won.tscn")
	else:
		var names = []
		for e in enemies:
			names.append(e.name)
		print("[GameManager] ❌ Player hasn't won yet. Enemies remaining:", names)
