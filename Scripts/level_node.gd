# LevelButton.gd
extends Button

var level_number = 0
var unlocked = false

func set_level_number(num: int):
	level_number = num
	$Label.text = "Level %d" % level_number
	unlocked = false
	_update_visual()

func unlock():
	unlocked = true
	_update_visual()

func _update_visual():
	# Change button modulate, disabled state, etc based on unlocked
	self.disabled = not unlocked
	self.modulate = Color(1, 1, 1) if unlocked else Color(0.5, 0.5, 0.5)
