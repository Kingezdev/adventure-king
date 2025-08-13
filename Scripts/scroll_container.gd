extends ScrollContainer

@export var recent_stage_name: String = "Stage_1" # Name of the node for recent unlocked stage

func _ready():
	await get_tree().process_frame # Wait for layout to complete
	scroll_to_recent_stage()

func scroll_to_recent_stage():
	var stage_node = get_node_or_null(recent_stage_name)
	if stage_node:
		# Convert stage position to ScrollContainer coordinates
		var stage_pos = stage_node.global_position.y - global_position.y
		scroll_vertical = stage_pos
