extends StaticBody2D

"""
Lever that can be used to toggle some kind of control in game. Starts in neutral
position, then toggles between on and off. Emits a signal that when toggled
that can be caught elsewhere to do something.
"""

signal lever_toggled(state: LeverStates)

@onready var interaction_area = $InteractionArea
@onready var animation_player = $Sprite2D/AnimationPlayer

# Possible lever states
enum LeverStates {
	ON,
	OFF,
	NEUTRAL,
}

# Current state
var state: LeverStates

# Enabled
var enabled: bool

# Set to neutral and enabled by default
func _ready():
	enabled = true
	state = LeverStates.NEUTRAL
	animation_player.play("neutral")
	interaction_area.interact = Callable(self, "pull_lever")

# Interact with the lever, if allowed
func pull_lever():
	if !enabled:
		return
	
	# Control state and animation
	if state == LeverStates.NEUTRAL or state == LeverStates.OFF:
		state = LeverStates.ON
		animation_player.play("on")
	else:
		state = LeverStates.OFF
		animation_player.play("off")
	
	# Toggle platform movement
	lever_toggled.emit(state)
