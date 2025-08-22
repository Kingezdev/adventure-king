extends Control

var dialogues = [
	{ "speaker": 0, "name": "Vince", "text": "So... this is it, boys and girls. Final hand..." },
	{ "speaker": 1, "name": "Lora", "text": "You sure you want in on this, Isaac?" },
	{ "speaker": 3, "name": "Mc", "text": "And yet... I’m still sitting here..." },
	{ "speaker": 2, "name": "Marco", "text": "You got balls, Rehn. Showing up with your bankruptcy face..." },
	{ "speaker": 0, "name": "Vince", "text": "Let’s play. Cards down. Eyes up" }
]

var current_index: int = 0

@onready var characters := [
	$Vince,
	$Lora,
	$Marco,
	$Mc
]

func _ready():
	_hide_all_boxes()
	show_dialogue()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		var line = dialogues[current_index]
		var box = characters[line["speaker"]].get_node("DialogueBox") as RichTextLabel

		if box._typing:
			box.skip_typing()  # First press skips typing
		else:
			next_dialogue()   # Second press continues

func _handle_input():
	if current_index >= dialogues.size():
		return

	var speaker_id = dialogues[current_index]["speaker"]
	var box = characters[speaker_id].get_node("DialogueBox")

	# If typing is still in progress, skip it
	if box.has_method("skip_typing") and box._typing:
		box.skip_typing()
	else:
		# Otherwise, go to the next dialogue
		next_dialogue()

func _hide_all_boxes():
	for c in characters:
		c.get_node("DialogueBox").visible = false

func show_dialogue():
	if current_index >= dialogues.size():
		# Dialogue is done → switch to GameLayer
		hide()  # hide the dialogue UI
		var game_layer = get_parent().get_node("GameLayer")
		game_layer.show()
		return

	var line = dialogues[current_index]
	var speaker_id = line["speaker"]
	var text = line["text"]
	var speaker_name = line["name"]

	_hide_all_boxes()

	for i in characters.size():
		var sprite = characters[i]
		var box = sprite.get_node("DialogueBox") as RichTextLabel
		var name_label = sprite.get_node("NameLabel") as Label
		
		if name_label:
			name_label.text = speaker_name
			name_label.visible = true
		if i == speaker_id:
			# Active speaker: normal
			sprite.modulate = Color(1, 1, 1, 1)
			name_label.text = speaker_name
			name_label.visible = true
			box.visible = true
			box.start_typing(text)  # typewriter effect here
		else:
			# Non-speakers: dim/blur
			sprite.modulate = Color(0.5, 0.5, 0.5, 0.7)
			name_label.visible = false
			box.visible = false

func next_dialogue():
	if current_index < dialogues.size() - 1:
		current_index += 1
		show_dialogue()
	else:
		# dialogue is finished, go to gameplay layer
		_end_dialogue()
		
func _end_dialogue():
	hide()  # hide dialogue UI
	
	# If game layer exists in the same scene
	var game_layer = get_parent().get_node_or_null("GameLayer")
	if game_layer:
		game_layer.show()
