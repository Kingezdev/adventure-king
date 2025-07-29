class_name PlayerStats
extends Control

@onready var health_bar: ProgressBar = %Health_bar

var max_health: int = 100
var current_health: int = max_health

func _ready():
	print("[PlayerStats] _ready() called")
	print("[PlayerStats] Initial HP:", current_health)
	update_health_bar()
	print("[PlayerStats] _ready() called - instance id:", self.get_instance_id())

func take_damage(amount: int):
	print("[PlayerStats] Taking damage:", amount)
	current_health = max(current_health - amount, 0)
	print("[PlayerStats] New HP after damage:", current_health)
	update_health_bar()

func update_health_bar():
	print("[PlayerStats] Updating health bar to:", current_health)
	health_bar.value = current_health
