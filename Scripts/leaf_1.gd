extends Sprite2D

@export var fall_speed_min := 50.0
@export var fall_speed_max := 150.0
@export var drift_speed := 30.0
@export var drift_range := 50.0
@export var rotation_speed := 30.0   # degrees/sec for subtle spin

var fall_speed := 0.0
var drift_direction := 1
var start_x := 0.0
var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	randomize_leaf()

func _process(delta: float) -> void:
	# fall
	position.y += fall_speed * delta

	# horizontal drift
	position.x += drift_direction * drift_speed * delta
	if abs(position.x - start_x) > drift_range:
		drift_direction *= -1

	# subtle rotation
	rotation_degrees += rotation_speed * delta * 0.3 * drift_direction

	# reset if below screen
	if position.y > get_viewport_rect().size.y + 50:
		randomize_leaf()

func randomize_leaf():
	var screen_size = get_viewport_rect().size
	position = Vector2(rng.randf_range(0, screen_size.x), rng.randf_range(-100, 0))
	fall_speed = rng.randf_range(fall_speed_min, fall_speed_max)
	start_x = position.x
	drift_direction = 1 if rng.randi() % 2 == 0 else -1
	rotation_degrees = rng.randf_range(-30, 30)
