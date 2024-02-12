extends StaticBody2D

"""
Lever that can be used to toggle some kind of control in game. Starts in neutral
position, then toggles between on and off. Emits a signal that when toggled
that can be caught elsewhere to do something.
"""

signal lever_toggled(state: LeverStates)
@export var platform_id:int

@onready var interaction_area = $InteractionArea
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D

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
	interaction_area.enabled = true
	state = LeverStates.OFF
	animation_player.play("off")
	interaction_area.interact = Callable(self, "pull_lever")
	interaction_area.position_y = -25

# Interact with the lever, if allowed
func pull_lever():
	if !enabled:
		return
	print("pull")
	audio_player.play()
	
	# Control state and animation
	if state == LeverStates.NEUTRAL or state == LeverStates.OFF:
		state = LeverStates.ON
		animation_player.play("on")
		enabled = false
		interaction_area.enabled = false
	else:
		state = LeverStates.OFF
		animation_player.play("off")
	
	# Toggle platform movement
	for platform in get_tree().get_nodes_in_group("MovingPlatform"):
		if platform.id == platform_id:
			platform.playAnimation()
	
	
	#lever_toggled.emit(state)
