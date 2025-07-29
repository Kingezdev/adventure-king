extends Area2D

@export var attack_damage := 10
@export var attack_duration := 1.0  # seconds to simulate attack animation or delay
@export var max_health := 100
var current_health := max_health

var player_stats_ref: Node = null
var is_mouse_over := false
var health_bar: ProgressBar

func _ready():
	print("[Enemy] Ready - name:", name)
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	add_to_group("Enemies")

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
		
func perform_attack():
	print(name, "is attacking for", attack_damage, "damage!")
	play_attack_animation()
	# Optional: Play attack animation/sound here
	await get_tree().create_timer(attack_duration).timeout

	if not UserStats:
		push_error("[Enemy] ❌ UserStats singleton is missing!")
		return
	
	UserStats.take_damage(attack_damage)
	print("[Enemy] Called take_damage() on UserStats for", attack_damage, "damage")
	
func play_attack_animation():
	var original_position = position
	var attack_offset = Vector2(12, 0)  # Move slightly right; adjust as needed
	var tween = get_tree().create_tween()

	tween.tween_property(self, "position", original_position + attack_offset, 0.1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "position", original_position, 0.1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)\
		.set_delay(0.1)

	
func on_card_selected():
	var tween = $Tween
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func on_card_deselected():
	var tween = $Tween
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func reset_scale():
	var tween = $Tween
	if is_instance_valid(tween):
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)		

func set_player_stats(player_stats_node: Node) -> void:
	player_stats_ref = player_stats_node
