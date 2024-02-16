class_name Star
extends Node2D

"""
Star that is collected as part of the points for the level.
"""

# Signal that is sent when the star is picked up
signal collected()

@onready var collection_area = $CollectionArea

# Send a message to level script to add a star to be collected, free from queue/destroy
func _on_collection_area_body_entered(body):
	if body is Protagonist:
			collected.emit()
			queue_free()
