class_name Level
extends Node2D

"""
Script holding functions data and functions that will exist across all levels. Think of this as a 
kind of abstract superclass for a level.
"""

# The name of the level
@export var level_name: String

# The main playable character
@export var protagonist: Protagonist

# Level's user interface
#@export var level_ui: LevelUI

# Area that when entered is the end of the level
@export var end: Area2D

# Stars to be collected
#@export var stars: Array[Star]

# Is this the second part of a multi-scene level
@export var has_prev_stage: bool = false

@export var prev_stage_name: String

# Stopwatch to keep track of score
@onready var stopwatch: Stopwatch = $LevelUI/Stopwatch

@onready var camera: Camera2D = $Camera2D

# Stars that have been collected
var collected_stars: int = 0


# Ready
func _ready() -> void:
	camera.global_position = protagonist.global_position
	Global.protagonist = protagonist
	
	# Set up end signal
	end.body_entered.connect(level_end)
	
	# Setup signal for each star
	#for star in get_tree().get_nodes_in_group("star"):
		#star.collected.connect(collect_star)

# Repositioning the camera
func _process(_delta) -> void:
	var x = 0
	var y = 0
	var size = 0
	for p in get_tree().get_nodes_in_group("protagonist"):
		x += p.global_position.x
		y += p.global_position.y
		size += 1

	camera.global_position.x = int(x / size)
	camera.global_position.y = int(y / size)

# Track collected stars
func collect_star() -> void:
	collected_stars += 1
	
# Catches signal that is emitted when the player reaches the end of the level
func level_end(body) -> void:
	if not body.is_in_group("protagonist"):
		return

	# Get player's scores for this run
	stopwatch.stop_stopwatch()
	var time: float = stopwatch.get_best_time()
	
	# Stop player from moving
	# protagonist.disable()
	
	# Get best scores
	var level_high_score: LevelHighScore = Global.high_scores.get_level_high_score(level_name)
	var best_time: float = level_high_score.get_best_time()
	var best_stars: int = level_high_score.get_best_stars()
	
	if has_prev_stage:
		var prev_stage_score: LevelHighScore = Global.high_scores.get_level_high_score(prev_stage_name)
		var prev_stage_last_time: float = prev_stage_score.get_last_time()
		time += prev_stage_last_time
	
	# Update saved data
	Global.high_scores.new_last_time(level_name, time)
	if time < best_time:
		Global.high_scores.new_low_time(level_name, time)
	if collected_stars > best_stars:
		Global.high_scores.new_high_stars(level_name, collected_stars)
	
	# Go back to the main menu
	SceneManager.load_new_scene(Global.MENU_PATH)
	
# Called by the SceneManager once the transition complete.
# Here you can initialize the player location, make player visible again, etc.
func enter_level() -> void:
	protagonist.enable()
