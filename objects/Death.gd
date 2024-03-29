extends Area2D

signal respawn

@onready var protagonist_escher = preload("res://characters/protagonist_escher.tscn")
@onready var protagonist_gogh = preload("res://characters/protagonist_gogh.tscn")

var duplicatedNode

func _on_body_entered(body):
	var greatest_x_below_target = -INF
	var checkpoint
	
	if body.is_in_group("protagonist"):
		for node in get_tree().get_nodes_in_group("checkpoint"):
			if node.global_position.x < body.global_position.x and node.global_position.x > greatest_x_below_target:
				greatest_x_below_target = node.global_position.x
				checkpoint = node
		for p in get_tree().get_nodes_in_group("protagonist"):
			p.queue_free()
		
		# Check if a valid x value was found
		if greatest_x_below_target != -INF:
			var curr_scene = get_tree().get_current_scene().get_name()
			if curr_scene == "Gogh" or curr_scene == "Gogh2":
				respawn.emit()
				return
			elif curr_scene == "Escher":
				duplicatedNode = protagonist_escher.instantiate()
			duplicatedNode.global_position.x = checkpoint.global_position.x
			if "x_offset" in checkpoint:
				duplicatedNode.global_position.x += checkpoint.x_offset
			duplicatedNode.global_position.y = checkpoint.global_position.y
			if "y_offset" in checkpoint:
				duplicatedNode.global_position.y += checkpoint.y_offset
			get_tree().current_scene.add_child(duplicatedNode)
			duplicatedNode.set_gravity("down")
		else:
			get_tree().reload_current_scene()
