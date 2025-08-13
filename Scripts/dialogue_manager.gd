extends Node

var dialogue_lines: Array = []
var current_line_index: int = 0
var callback_after: Callable = func(): pass  # Default empty callable

# Start dialogue from an already loaded Array
func start_dialogue(lines: Array, after_callback: Callable = func(): pass):
	print("[DEBUG] Starting dialogue with %d lines" % lines.size())
	dialogue_lines = lines
	current_line_index = 0
	callback_after = after_callback
	show_current_line()

# Start dialogue directly from a JSON file path
func start_dialogue_from_file(file_path: String, after_callback: Callable = func(): pass):
	print("[DEBUG] Attempting to load dialogue file:", file_path)
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		print("[DEBUG] File read successfully, parsing JSON...")

		var result = JSON.new()
		var parse_error = result.parse(json_text) # This one gives error info
		if parse_error != OK:
			push_error("❌ JSON parse error in %s: %s at line %d, column %d" % [
				file_path,
				result.get_error_message(),
				result.get_error_line(),
				result.get_error_column()
			])
			return

		var data = result.data
		if data is Array:
			print("[DEBUG] ✅ JSON parsed successfully, array length:", data.size())
			start_dialogue(data, after_callback)
		else:
			push_error("❌ Dialogue file at %s is not an Array" % file_path)
	else:
		push_error("❌ Could not open dialogue file: %s" % file_path)


# Show current dialogue line
func show_current_line():
	if current_line_index < dialogue_lines.size():
		var line = dialogue_lines[current_line_index]
		print("[DEBUG] Showing line %d" % current_line_index)
		print("%s: %s" % [line.get("name", "Unknown"), line.get("text", "")])
	else:
		print("[DEBUG] No more lines, ending dialogue")
		end_dialogue()

# Advance to next line
func next_line():
	print("[DEBUG] Moving to next line")
	current_line_index += 1
	if current_line_index < dialogue_lines.size():
		show_current_line()
	else:
		print("[DEBUG] Reached end of dialogue lines")
		end_dialogue()

# End dialogue
func end_dialogue():
	print("[DEBUG] Dialogue ended")
	callback_after.call()
