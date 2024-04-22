extends Node2D

"""
Loading/intro screen for each level.
"""

@export var level_name: String

# Default 4 second wait time
@export var wait_time: int = 4

@onready var animation = $AnimationPlayer
@onready var timer = $Timer

var time = 0

func _ready():
	animation.play("dissolve")
	timer.set_wait_time(wait_time)
	timer.start()
	#var scene_name = Global.LEVELS_PATH + level_name + ".tscn"
	#ResourceLoader.load_threaded_request(scene_name)
	
func _process(_delta):
	#var scene_name = Global.LEVELS_PATH + level_name + ".tscn"
	#var loaded = ResourceLoader.load_threaded_get_status(scene_name)
	#if loaded == ResourceLoader.THREAD_LOAD_LOADED and time > 6:
		#var level = ResourceLoader.load_threaded_get(scene_name)
		#get_tree().change_scene_to_packed(level)
	pass

func _on_timer_timeout():
	SceneManager.load_new_scene(Global.LEVELS_PATH + level_name + ".tscn")
