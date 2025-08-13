extends Node

var dialogues : Array = []
var current_index : int = 0
var callback_after : Callable = func(): pass  # Empty callable as default

func load_dialogue(stage_number: int, after_callback: Callable = func(): pass) -> void:
	var file_path = "res://data/dialogues/stage_%d.json" % stage_number
	print("[DEBUG] Attempting to load dialogue file:", file_path)

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		print("[DEBUG] File read successfully, parsing JSON...")
		var json_data = JSON.parse_string(json_text)

		if typeof(json_data) == TYPE_ARRAY:
			dialogues = json_data
			current_index = 0
			callback_after = after_callback
			print("[DEBUG] Loaded %d dialogue lines" % dialogues.size())
			show_current_line()
		else:
			push_error("Invalid dialogue format in: %s (Expected Array)" % file_path)
	else:
		push_error("Dialogue file not found: %s" % file_path)

func next_line() -> void:
	print("[DEBUG] Moving to next line...")
	current_index += 1
	if current_index >= dialogues.size():
		print("[DEBUG] No more dialogue lines")
		if callback_after:
			print("[DEBUG] Calling callback_after...")
			callback_after.call()
	else:
		show_current_line()

func show_current_line() -> void:
	if current_index < dialogues.size():
		var line = dialogues[current_index]
		if line.has("name") and line.has("text"):
			print("[DEBUG] Showing line %d" % current_index)
			print("%s: %s" % [line["name"], line["text"]])
		else:
			push_warning("[WARNING] Dialogue entry missing 'name' or 'text' at index %d" % current_index)
	else:
		print("[DEBUG] Tried to show a line beyond the end of the dialogues")
