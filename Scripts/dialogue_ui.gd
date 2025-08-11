extends Control

@onready var name_label = $NameLabel
@onready var portrait = $CharacterPortrait
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var timer = $Timer

var dialogues = [
	{"name": "Yota", "portrait": "res://Assets/Player/mc.png", "text": "Hello there!"},
	{"name": "Bob", "portrait": "res://icon.png", "text": "Welcome to the test."}
]

var current_index = 0
var full_text = ""
var char_index = 0
var typing = false
var type_speed = 0.03

func _ready():
	show_dialogue()

func show_dialogue():
	if current_index >= dialogues.size():
		print("Dialogue finished.")
		return
	
	var entry = dialogues[current_index]
	name_label.text = entry.name
	portrait.texture = load(entry.portrait)
	full_text = entry.text
	dialogue_text.clear()
	char_index = 0
	typing = true
	timer.start(type_speed)

func _on_Timer_timeout():
	if typing:
		if char_index < full_text.length():
			dialogue_text.append_text(full_text[char_index])
			char_index += 1
		else:
			typing = false
			timer.stop()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if typing:
			dialogue_text.text = full_text
			typing = false
			timer.stop()
		else:
			current_index += 1
			show_dialogue()
