extends Control

@export var card_id: String = "Zorto"
@export var mana_cost := 5
@export var damage: int = 10
@onready var tween := get_tree().create_tween()
var is_selected := false  # <-- new

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	print("[Card] Ready - name:", name, "damage:", damage)
	# Connect signals for hover
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func _on_mouse_entered():
	if is_selected:
		return  # Don't
	# Scale up smoothly
	tween.kill()  # Stop previous animations
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func _on_mouse_exited():
	if is_selected:
		return  # Stay zoomed in
	# Reset scale smoothly
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("[Card] Card clicked:", name)
		GameManager.select_card(self)
		accept_event()  # ✅ For Control nodes

func get_damage():
	return damage
	
func set_selected(value: bool) -> void:
	is_selected = value
	tween.kill()
	tween = get_tree().create_tween()
	if value:
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
