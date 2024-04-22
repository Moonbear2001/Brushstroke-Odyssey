extends Node2D

@export var level_name: String

@onready var animation = $AnimationPlayer
@onready var timer = $Timer

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("dissolve")
	var scene_name = Global.LEVELS_PATH + level_name + ".tscn"
	ResourceLoader.load_threaded_request(scene_name)
	
func _process(delta):
	var scene_name = Global.LEVELS_PATH + level_name + ".tscn"
	var loaded = ResourceLoader.load_threaded_get_status(scene_name)
	if loaded == ResourceLoader.THREAD_LOAD_LOADED and time > 6:
		var level = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(level)
	
	
	## DOESN'T WORK
	#if time > 6:
		#SceneManager.load_new_scene(Global.LEVELS_PATH + level_name + ".tscn")

func _on_timer_timeout():
	time += 1
