extends Node

"""
Global script where global variables, constants, functions, etc. can be stored
and accessed anywhere throughout the project.
"""

# Global constants
const LEVELS = ["tutorial", "escher", "gogh", "dali"]
const SAVE_DATA_PATH = "user://"
const LEVELS_PATH = "res://levels/"
const MENU_PATH = LEVELS_PATH + "menu.tscn"


# Global variables
var high_scores : HighScores
var user_settings: UserSettings
var waiting_for_duplicate: bool = false
var scene_transitioning = false
var menu_pos = Vector2.ZERO

# Stuff that should happen on game start up
func _ready() -> void:
	create_or_load_high_scores()
	create_or_load_user_settings()


# Global inputs
func _input(_event) -> void:
	
	# Only accept input if we are not transitioning between scenes
	if !scene_transitioning:
		
		# Open settings
		if Input.is_action_just_pressed("settings"):
			Settings.toggle_settings_window()
		

# Check if saved scores file exists, create a new one if not
func create_or_load_high_scores() -> void:
	if HighScores.high_scores_exist():
		high_scores = HighScores.load_high_scores() as HighScores
	else:
		high_scores = HighScores.new()
		high_scores.reset_scores()
		
# Check if saved user settings file exists, create a new one if not
func create_or_load_user_settings() -> void:
	if UserSettings.user_settings_exist():
		user_settings = UserSettings.load_user_settings() as UserSettings
	else:
		user_settings = UserSettings.new()
		user_settings.reset_settings()
