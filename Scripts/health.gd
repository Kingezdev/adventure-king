extends Area2D

@export var max_health := 50
var current_health := max_health

var is_mouse_over := false
var health_bar: ProgressBar

func _ready():
	print("[Enemy] Ready - name:", name)
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

	# Get the health bar node
	health_bar = $HealthBar
	health_bar.max_value = max_health
	health_bar.value = current_health

func _process(delta):
	if is_mouse_over and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print("[Enemy]  Clicked via mouse over:", name)
		GameManager.use_selected_card_on(self)

func _on_mouse_entered():
	is_mouse_over = true
	print("[Enemy]  Mouse entered:", name)

func _on_mouse_exited():
	is_mouse_over = false
	print("[Enemy]  Mouse exited:", name)

func take_damage(amount: int):
	current_health -= amount
	current_health = max(current_health, 0)
	print("[Enemy] Took damage:", amount, " | New HP:", current_health)

	# Update the health bar
	if health_bar:
		health_bar.value = current_health

	if current_health == 0:
		print("[Enemy] ", name, "has died.")
		queue_free()
