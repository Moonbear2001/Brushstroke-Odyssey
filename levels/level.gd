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

# Level transition stuff
@export var level_doors: Array[LevelDoor]
var data: LevelDataHandoff

# Stopwatch to keep track of score
@export var stopwatch: Stopwatch

# Area that when entered is the end of the level
@export var end: Area2D

# Ready
func _ready() -> void:
	
	# Disable input from the player and make player invisible while transitioning levels
	protagonist.disable()
	
	# If we're not transitioning between levels, there won't be any LevelHandoffData and we don't
	# need to wait for the SceneManager to call this
	if data == null:
		# print("Not transitioning between levels")
		enter_level()
	
	# Set up end signal
	end.body_entered.connect(level_end)


# Called by the SceneManager once the transitionis complete.
# Enter a level, initialize the player location, make player visible again
func enter_level() -> void:
	if data != null: 
		init_player_location()
	protagonist.enable()
	_connect_to_level_doors()


# !! PLAYER NOT BEING POSITIONED FOR THE MOMENT
# Put player in front of the correct door
func init_player_location() -> void:
	pass
	#for door in level_doors:
		#if door.name == data.entry_door_name:
			#protagonist.position = door.get_player_entry_vector()


# Signal emitted by LevelDoor when the player enters it.
# Disables level_doors and players.
# Creates handoff data to pass to the new scene.
func _on_player_entered_door(door: LevelDoor) -> void:
	
	# print("On player entered door signal caught in level script")
	
	_disconnect_from_level_doors()
	protagonist.disable()
	protagonist.queue_free()
	data = LevelDataHandoff.new()
	data.entry_door_name = door.entry_door_name
	#data.move_dir = door.get_move_dir()
	#print("LevelDataHandoff, entry door name : ", data.entry_door_name, " move_dir: ", data.move_dir)
	# print("LevelDataHandoff, entry door name : ", data.entry_door_name)
	# set_process(false)


# Connect each door leading to another level to the signal
func _connect_to_level_doors() -> void:
	for level_door in level_doors:
		if not level_door.player_entered_door.is_connected(_on_player_entered_door):
			level_door.player_entered_door.connect(_on_player_entered_door)


# Disconnect each door leading to another level from the signal
func _disconnect_from_level_doors() -> void:
	for level_door in level_doors:
		if level_door.player_entered_door.is_connected(_on_player_entered_door):
			level_door.player_entered_door.disconnect(_on_player_entered_door)


# Catches signal that is emitted when the player reaches the end of the level
func level_end(body):
	
	# Get player's score for this run and save if its a high score
	stopwatch.stop_stopwatch()
	var time = stopwatch.get_time()
	var high_score = Global.high_scores.get_level_high_score(level_name)
	if time < high_score:
		Global.high_scores.new_high_score(level_name, time)

	# Go back to the main menu
	SceneManager.load_new_scene(Global.MENU_PATH)

