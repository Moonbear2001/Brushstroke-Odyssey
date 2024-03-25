extends Node2D

"""
Basically a ladder. 
Sends a signal when the protagonist reaches the top. Catch this signal somewhere 
else in the scene to make something happens when the protag finishes climbing.
"""

signal top_reached()

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("protagonist"):
		print("setting climb true")
		body.climb = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("protagonist"):
		print("setting climb false")
		body.climb = false
