extends Node2D

"""
Loading/intro screen for each level.
"""

@export var level_name: String

# Default 4 second wait time
@export var wait_time: int = 4
@onready var timer = $Timer

var time = 0

func _ready():
	timer.set_wait_time(wait_time)
	timer.start()
	#var scene_name = Global.LEVELS_PATH + level_name + ".tscn"
	#ResourceLoader.load_threaded_request(scene_name)

func _on_timer_timeout():
	SceneManager.load_new_scene(Global.LEVELS_PATH + level_name + ".tscn")
