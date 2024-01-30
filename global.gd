extends Node

"""
Global script where global variables, constants, functions, etc. can be stored
and accessed anywhere throughout the project.
"""

# Global constants
const LEVELS = ["tutorial", "escher"]
const SAVE_DATA_PATH = "user://"
const MENU_PATH = "res://main.tscn"

# Global variables
var high_scores : HighScores
var waiting_for_duplicate: bool = false

# Stuff that should happen on game start up
func _ready() -> void:
	create_or_load_high_scores()


# Global inputs
func _input(_event) -> void:
	
	# Player can go back to the menu at any time by pressing 'escape'
	if Input.is_action_just_pressed("menu"):
		SceneManager.load_new_scene("res://main.tscn")
		

# Check to see if a save file exists, create a new one if not
func create_or_load_high_scores() -> void:
	if HighScores.high_scores_exist():
		high_scores = HighScores.load_high_scores() as HighScores
	else:
		high_scores = HighScores.new()
		high_scores.reset_scores()
