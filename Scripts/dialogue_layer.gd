extends Control

var dialogues = [
	{ "speaker": 0, "text": "So... this is it, boys and girls. Final hand. Stakes are set. One winner takes the pot... and maybe a little more." },
	{ "speaker": 1, "text": "You sure you want in on this, Isaac? You’ve lost more than just money in places like this" },
	{ "speaker": 3, "text": "And yet... I’m still sitting here. Maybe tonight’s my turn" },
	{ "speaker": 2, "text": "You got balls, Rehn. Showing up with your bankruptcy face and bluffing like a goddamn king" },
	{ "speaker": 0, "text": "Let’s play. Cards down. Eyes up" }
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
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		_handle_input()

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
		hide()
		return

	var line = dialogues[current_index]
	var speaker_id = line["speaker"]
	var text = line["text"]

	# Highlight current speaker and dim others
	for i in range(characters.size()):
		var sprite = characters[i]
		var box = sprite.get_node("DialogueBox") as RichTextLabel

		if i == speaker_id:
			sprite.modulate = Color(1, 1, 1, 1)
			box.visible = true
			if box.has_method("start_typing"):
				box.start_typing(text)
			else:
				box.text = text
		else:
			sprite.modulate = Color(0.5, 0.5, 0.5, 0.7)
			box.visible = false

func next_dialogue():
	current_index += 1
	show_dialogue()
