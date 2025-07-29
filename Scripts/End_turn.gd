extends Control

var end_turn_triggered := false

func _on_end_turn_button_pressed():
	end_turn_triggered = true
	$Turn/AnimatedSprite2D.play("snd_turn")

func _on_button_pressed() -> void:
	# Play hourglass animation
	$Turn/AnimatedSprite2D.play("end_turn")  # Replace "hourglass" with your actual animation name

	# Call your end turn logic (e.g., in a GameManager)
	GameManager.enemies_attack()

func _on_animated_sprite_2d_animation_finished():
	if end_turn_triggered:
		GameManager.end_turn()
		end_turn_triggered = false
