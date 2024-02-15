extends Area2D

@onready var protagonist = preload("res://characters/protagonist.tscn")
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
		for p in get_tree().get_nodes_in_group("protagonist"):
			p.queue_free()
		
		# Check if a valid x value was found
		if greatest_x_below_target != -INF:
			var duplicatedNode: Protagonist = protagonist.instantiate()
			duplicatedNode.global_position.x = door.global_position.x + door.x_offset
			duplicatedNode.global_position.y = door.global_position.y + door.y_offset
			get_tree().current_scene.add_child(duplicatedNode)
			duplicatedNode.set_gravity("down")
		else:
			get_tree().reload_current_scene()
