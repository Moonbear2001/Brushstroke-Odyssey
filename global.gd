extends Node

"""
Global script where global variables, constants, functions, etc. can be stored
and accessed anywhere throughout the project.
"""

# Global inputs
func _input(event) -> void:
	
	# Player can go back to the menu at any time by pressing 'escape'
	if Input.is_action_just_pressed("menu"):
		SceneManager.load_new_scene("res://main.tscn")
