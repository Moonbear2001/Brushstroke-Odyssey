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

# Ready
func _ready() -> void:
	
	# Disable input from the player and make player invisible while transitioning levels
	protagonist.disable()
	
	# If we're not transitioning between levels, there won't be any LevelHandoffData and we don't
	# need to wait for the SceneManager to call this
	if data == null:
		# print("Not transitioning between levels")
		enter_level()


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


