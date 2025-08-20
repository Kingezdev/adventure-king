extends RichTextLabel

@export var typing_speed := 0.05  # seconds per character

var _full_text := ""
var _typing := false

# Start typing text
func start_typing(text: String) -> void:
	_full_text = text
	clear()
	_typing = true
	_typewriter_loop()  # start the loop without blocking

# Typewriter loop that respects skip
func _typewriter_loop() -> void:
	for i in _full_text.length():
		if not _typing:
			# Player pressed Enter → stop typing
			break
		add_text(_full_text[i])
		await get_tree().create_timer(typing_speed).timeout
	_typing = false
	# Make sure full text is visible if loop ended naturally
	add_text(_full_text.substr(get_total_character_count(), _full_text.length() - get_total_character_count()))

# Skip typing and show full text
func skip_typing() -> void:
	if _typing:
		_typing = false
		clear()
		add_text(_full_text)
