class_name SceneTransition
extends CanvasLayer

"""
Flexible system for adding different animations between scene (ie. level) transitions.
"""

signal transition_in_complete

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var starting_animation_name: String

# Called by the SceneManager, plays the intro to the level transition
func start_transition(animation_name: String) -> void:
	
	# Make sure the chosen animation exists, otherwise use default intro
	if !anim_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"
	starting_animation_name = animation_name
	anim_player.play(animation_name)
	
# Called by SceneManager, plays the outro to the level transition
func finish_transition() -> void:

	# Construct second half of the transitation's animation name
	var ending_animation_name: String = starting_animation_name.replace("to", "from")
	
	# Make sure the chosen animation exists, otherwise use default outro
	if !anim_player.has_animation(ending_animation_name):
		push_warning("'%s' animation does not exist" % ending_animation_name)
		ending_animation_name = "fade_from_black"
	anim_player.play(ending_animation_name)
	
	# Free the scene (ie. remove from the tree) once the animation ends
	await anim_player.animation_finished
	queue_free()

# Method built into intro animations. Reports when that animation has finished so that 
# we can emit a signal telling the SceneManager to start loading in the new scene
func report_midpoint() -> void:
	transition_in_complete.emit()
