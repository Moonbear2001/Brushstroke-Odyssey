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
const DEF_MENU_POS = Vector2(1500, 500)

# Global variables
var high_scores : HighScores
var user_settings: UserSettings
var waiting_for_duplicate: bool = false
var scene_transitioning = false
var menu_pos = Vector2.ZERO

# Global reference to the protagonist that global scripts share
@onready var protagonist: Protagonist = get_tree().get_first_node_in_group("protagonist")

# Stuff that should happen on game start up
func _ready() -> void:
	SceneManager.new_scene_loaded.connect(on_new_scene_loaded)
	menu_pos = DEF_MENU_POS
	create_or_load_high_scores()
	create_or_load_user_settings()

# Remove the game from transitioning state and refresh the global ref to the protagonist
func on_new_scene_loaded() -> void:
	scene_transitioning = false
	protagonist = get_tree().get_first_node_in_group("protagonist")

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
