class_name Star
extends Node2D

"""
Star that is collected as part of the points for the level.
"""

# Signal that is sent when the star is picked up
signal collected()

@onready var interaction_area = $InteractionArea

# TODO: add animations and sound when collected
#@onready var animation_player = $Sprite2D/AnimationPlayer
#@onready var audio_player = $AudioStreamPlayer2D

# Ready
func _ready():
	interaction_area.enabled = true
	interaction_area.interact = Callable(self, "collect_star")
	interaction_area.position_y = -25

# Collect the star
func collect_star() -> void:
	# Send a message to level script to add a star to be collected
	collected.emit()
	print("collected")
	
	# Free from queue/destroy
	queue_free()
