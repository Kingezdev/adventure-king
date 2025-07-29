extends ProgressBar

@export var max_health: int = 100
var current_health: int = max_health

func _ready():
	max_value = max_health
	value = current_health
	print("[HealthBar] Ready - Max:%s Current:%s" % [max_value, value])

func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	print("[HealthBar] Took damage:", amount, " | New HP:", current_health)
	animate_health_change(current_health)

func animate_health_change(new_value: int) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "value", new_value, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
