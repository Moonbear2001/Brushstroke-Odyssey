extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	var greatest_x_below_target = -INF
	var door
	if body.is_in_group("protagonist"):
		for node in get_tree().get_nodes_in_group("checkpoint"):
			if node.global_position.x < body.global_position.x and node.global_position.x > greatest_x_below_target:
				greatest_x_below_target = node.global_position.x
				door = node

		# Check if a valid x value was found
		if greatest_x_below_target != -INF:
			body.global_position.x = door.global_position.x + door.x_offset
			body.global_position.y = door.global_position.y + door.y_offset
		else:
			get_tree().reload_current_scene()
