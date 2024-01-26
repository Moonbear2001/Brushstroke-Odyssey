extends Node2D

"""
Top level script for the Escher level. Currently just using to make the platform
move.
"""

@onready var moving_platform_animation_player = $"Platforms/Moving platform/AnimationPlayer"
@onready var lever = $Lever

# Have we moved the platform yet
var platform_moved: bool = false

# Ready
func _ready():
	
	# Stop the moving platform
	moving_platform_animation_player.stop()

# Called when the lever is pulled, toggles moving platform animation
func _on_lever_lever_toggled(lever_state):
	#lever.disable()
	if !platform_moved:
		moving_platform_animation_player.play("move_into_position")
		platform_moved = true
