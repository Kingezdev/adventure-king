extends Camera2D

var shake_amount := 4.0
var shake_duration := 0.2
var _timer := 0.0
var _original_offset := Vector2.ZERO

func _ready():
	_original_offset = offset

func _process(delta):
	if _timer > 0:
		_timer -= delta
		offset = _original_offset + Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
	else:
		offset = _original_offset

func start_shake(duration := 0.2, amount := 4.0):
	shake_duration = duration
	shake_amount = amount
	_timer = duration
