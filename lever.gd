extends StaticBody2D

"""
Lever
"""

signal toggle_moving_platform

@onready var interaction_area = $InteractionArea
@onready var rng = RandomNumberGenerator.new()

func _ready():
	interaction_area.interact = Callable(self, "pull_lever")

# Change color when interacted with
func pull_lever():
	
	# TODO: Add animation
	
	# Toggle platform movement
	toggle_moving_platform.emit()
