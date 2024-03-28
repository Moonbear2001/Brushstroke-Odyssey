extends Node2D

"""
Basically a ladder. 
Sends a signal when the protagonist reaches the top. Catch this signal somewhere 
else in the scene to make something happens when the protag finishes climbing.
"""
@onready var interaction_area = $InteractionArea

var entered = false
var enabled = true

signal top_reached()

# Got to top of ladder
func _on_top_body_entered(body):
	if body.is_in_group("protagonist") and Input.is_action_pressed("climb"):
		top_reached.emit()


func _on_body_entered(body):
	if body.is_in_group("protagonist"):
		if enabled:
			body.climb = true
		entered = true


func _on_body_exited(body):
	if body.is_in_group("protagonist"):
		body.climb = false
		entered = false

func disable():
	for node in get_tree().get_nodes_in_group('protagonist'):
		node.climb = false
		enabled = false
		
func enable():
	enabled = true
	if entered:
		for node in get_tree().get_nodes_in_group('protagonist'):
			node.climb = true
		

