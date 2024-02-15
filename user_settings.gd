class_name UserSettings
extends Resource

"""
A resource holding user settings that is saved and loaded in the users's 
directory. 
Each function that changes user settings should be ended with a save operation so that those 
functions can be safely called from outside this script.
"""

# All user settings go here
@export_range(0, 1, 0.05) var music_volume: float = 1.0
@export_range(0, 1, 0.05) var sfx_volume: float = 1.0
@export var music_muted: bool = false
@export var sfx_muted: bool = false

const USER_SETTINGS_PATH = Global.SAVE_DATA_PATH + "user_settings.tres"
const DEFAULT_VOLUME = 1.0

static func user_settings_exist() -> bool:
	return ResourceLoader.exists(USER_SETTINGS_PATH)

static func load_user_settings() -> Resource:
	return ResourceLoader.load(USER_SETTINGS_PATH)

func reset_settings() -> void:
	music_volume = DEFAULT_VOLUME
	save_user_settings()

func save_user_settings() -> void:
	ResourceSaver.save(self, USER_SETTINGS_PATH)


### Getters ###

func get_music_volume() -> float:
	return music_volume
	
func get_sfx_volume() -> float:
	return sfx_volume
	
func get_music_muted() -> bool:
	return music_muted
	
func get_sfx_muted() -> bool:
	return sfx_muted

	
### Setters ###

func set_music_volume(volume: float) -> void:
	music_volume = volume
	save_user_settings()
	
func set_sfx_volume(volume: float) -> void:
	sfx_volume = volume
	save_user_settings()
	
func set_music_mute(value: bool) -> void:
	music_muted = value
	save_user_settings()
	
func set_sfx_mute(value: bool) -> void:
	sfx_muted = value
	save_user_settings()
