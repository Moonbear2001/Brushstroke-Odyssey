extends StaticBody2D

"""
Lever
"""

signal toggle_moving_platform

@onready var interaction_area = $InteractionArea
@onready var animation_player = $Sprite2D/AnimationPlayer

# Possible lever states
enum states {
	ON,
	OFF,
	NEUTRAL,
}

# Current state
var state

# Ready
func _ready():
	interaction_area.interact = Callable(self, "pull_lever")
	state = states.NEUTRAL
	animation_player.play("neutral")

# Interaction with the lever
func pull_lever():
	
	# Control state and animation
	if state == states.NEUTRAL or state == states.OFF:
		state = states.ON
		animation_player.play("on")
	else:
		state = states.OFF
		animation_player.play("off")
	
	# Toggle platform movement
	toggle_moving_platform.emit()
