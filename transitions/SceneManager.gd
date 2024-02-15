extends Node

"""
Manages all the different scenes and the transitions between them in the game.
"""

signal content_finished_loading(content)
signal content_invalid(content_path: String)
signal content_failed_to_load(content_path: String)

var scene_transition: SceneTransition
var _scene_transition_scene: PackedScene = preload("res://transitions/scene_transition.tscn")
var _transition: String
var _content_path: String
var _load_progress_timer: Timer

# Ready
func _ready() -> void:
	content_finished_loading.connect(on_content_finished_loading)

# Loads the new scene
func load_new_scene(content_path: String, transition_type: String="fade_to_black") -> void:
	
	# Put game in transitioning state
	Global.scene_transitioning = true
	Settings.hide_settings_window()
	
	_transition = transition_type
	scene_transition = _scene_transition_scene.instantiate() as SceneTransition
	get_tree().root.add_child(scene_transition)
	scene_transition.start_transition(transition_type)
	_load_content(content_path)
	

# Tell the ResourceLoader to start loading the new scene
func _load_content(content_path: String) -> void:
	await scene_transition.transition_in_complete
	_content_path = content_path
	var loader = ResourceLoader.load_threaded_request(content_path)
	
	# What we tried to load doesn't exist
	if not ResourceLoader.exists(content_path) or loader == null:
		content_invalid.emit(content_path)
		return
	
	# Check on the status of the loading content every 0.1 seconds
	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.timeout.connect(monitor_load_status)
	get_tree().root.add_child(_load_progress_timer)
	_load_progress_timer.start()
	
# Check on the loading status and emit the correct signal if loading fails
func monitor_load_status() -> void:
	var load_progress = []
	var load_status = ResourceLoader.load_threaded_get_status(_content_path, load_progress)

	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			content_invalid.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#if loading_screen != null:
				#loading_screen.update_bar(load_progress[0] * 100) # 0.1
			return
		ResourceLoader.THREAD_LOAD_FAILED:
			content_failed_to_load.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			_load_progress_timer.stop()
			_load_progress_timer.queue_free()
			content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
			#content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path))
			return

# Prints an error message if content fails to load
func on_content_failed_to_load(path: String) -> void:
	printerr("error: Failed to load resource: '%s'" % [path])	

# Prints an error message if we tried to load invalid content
func on_content_invalid(path: String) -> void:
	printerr("error: Cannot load resource: '%s'" % [path])
	
func on_content_finished_loading(content) -> void:

	var outgoing_scene = get_tree().current_scene
	
	# If we're moving between Levels, pass LevelDataHandoff (the next Level's data) here
	#var incoming_data: LevelDataHandoff
	
	# TESTING
	#if get_tree().current_scene is Level:
		#incoming_data = get_tree().current_scene.data as LevelDataHandoff
	
	# If we are going to a level, pass the LevelHandoffData
	# TESTING
	#if content is Level:
		#content.data = incoming_data

	# Remove the old scene
	outgoing_scene.queue_free()
	
	# Add and set the new scene to current
	get_tree().root.call_deferred("add_child", content)
	get_tree().set_deferred("current_scene", content)
	
	if scene_transition != null:
		# Play transition outro
		scene_transition.finish_transition()
		
		# If were loading a level, load the player location
		#if content is Level:
			#content.init_player_location()
		
		# Wait for LoadingScreen's transition to finish playing
		await scene_transition.anim_player.animation_finished
		scene_transition = null
		if content is Level:
			content.enter_level()
			
	# Take game out of transitioning state
	Global.scene_transitioning = false
