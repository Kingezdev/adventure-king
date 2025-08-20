extends HBoxContainer

## Holds the cards in this deck
var cards: Array = []   # Example: [{"id": "fireball"}, {"id": "heal"}]

func _ready():
	print("[Deck] ✅ Ready - Current deck size:", cards.size())

# ----------------------------
# STATE -> ID LIST (for saving)
# ----------------------------
func get_deck_state() -> Array:
	# Return just the card IDs (or however you identify cards)
	return cards.map(func(card): return card.get("id"))

# ----------------------------
# RESTORE FROM ID LIST (loading)
# ----------------------------
func restore_deck_state(ids: Array) -> void:
	cards.clear()
	for id in ids:
		# Replace with your own card spawning/loading
		cards.append({"id": id})
	print("[Deck] ♻ Restored deck from save:", cards)

# ----------------------------
# MODIFYING DECK
# ----------------------------
func add_card(card_data: Dictionary) -> void:
	cards.append(card_data)
	print("[Deck] ➕ Added card:", card_data)

func remove_card(card_data: Dictionary) -> void:
	cards.erase(card_data)
	print("[Deck] ➖ Removed card:", card_data)

func shuffle() -> void:
	cards.shuffle()
	print("[Deck] 🔀 Shuffled:", cards)
