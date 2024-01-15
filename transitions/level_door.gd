class_name LevelDoor
extends Area2D

"""
Door for transitioning between levels.
"""

signal player_entered_door(door: LevelDoor, transition_type: String)

# Enum of all the types of transitions available to us
@export_enum("fade_to_black") var transition_type: String

# Path to the file holding the new scene
@export var path_to_new_scene: String

# The name of the door that this door leads to
@export var entry_door_name: String

# Called when a player enters a door
func _on_body_entered(body: Node2D) -> void:
	
	# If a body entered that is not the player, then ignore
	if not body is Protagonist:
		return
		
	# Tell the level scrip the player entered a door
	player_entered_door.emit(self)
	
	# Tell the SceneManager to load a new scene and play the transition
	SceneManager.load_new_scene(path_to_new_scene, transition_type)
	
	# Delete this door at the end of the frame (makes sure we only collide once)
	queue_free()

# Returns this doors position so that the player knows where to be when it exits
func get_player_entry_position() -> Vector2:
	return self.position

