extends Node2D

@onready var deck: HBoxContainer = $Deck
@onready var game_layer: Node2D = $GameLayer

@onready var target_node = $TargetNode
@onready var dependent_node = $DependentNode

func _ready():
	game_layer.connect("visibility_changed", Callable(self, "_on_target_visibility_changed"))
	deck.visible = game_layer.visible  # set initial state

func _on_target_visibility_changed():
	deck.visible = game_layer.visible
