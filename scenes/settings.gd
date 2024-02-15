extends Control

"""
Window for navigating to the menu, controlling user's volume, and resetting high scores.
"""

@onready var SFX_BUS_ID: int = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID: int = AudioServer.get_bus_index("Music")

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var music_check_btn: CheckButton = $CanvasLayer/ColorRect/VBoxContainer/GridContainer/MusicCheckBtn
@onready var sfx_check_btn: CheckButton = $CanvasLayer/ColorRect/VBoxContainer/GridContainer/SfxCheckBtn
@onready var music_slider: HSlider = $CanvasLayer/ColorRect/VBoxContainer/GridContainer/MusicVolumeSlider
@onready var sfx_slider: HSlider = $CanvasLayer/ColorRect/VBoxContainer/GridContainer/SfxVolumeSlider

var music_volume: float
var sfx_volume: float
var music_muted: bool
var sfx_muted: bool

func _ready():
	canvas_layer.hide()
	
	# Load saved settings
	var saved_settings: UserSettings = UserSettings.load_user_settings()
	music_volume = saved_settings.get_music_volume()
	sfx_volume = saved_settings.get_sfx_volume()
	music_muted = saved_settings.get_music_muted()
	print("music muted: ", music_muted)
	sfx_muted = saved_settings.get_sfx_muted()
	
	# Apply saved settings
	music_slider.value = music_volume
	sfx_slider.value = sfx_volume
	music_check_btn.button_pressed = !music_muted
	sfx_check_btn.button_pressed = !sfx_muted
	AudioServer.set_bus_mute(MUSIC_BUS_ID, music_muted)
	AudioServer.set_bus_mute(SFX_BUS_ID, sfx_muted)

# Open the settings page
func toggle_settings_window() -> void:
	if canvas_layer.visible:
		canvas_layer.hide()
	else:
		canvas_layer.show()
		
# Hide the settings sindow
func hide_settings_window() -> void:
	canvas_layer.hide()

# Quit the game
func _on_quit_btn_pressed():
	get_tree().quit()

# Go to main menu
func _on_menu_btn_pressed():
	SceneManager.load_new_scene(Global.MENU_PATH)

# Change and save music volume
func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	Global.user_settings.set_music_volume(value)

# Change and save sfx volume
func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	Global.user_settings.set_sfx_volume(value)

# Reset all scores
func _on_reset_scores_btn_pressed():
	Global.high_scores.reset_scores()

# Toggle music on/off
func _on_music_check_btn_toggled(toggled_on):
	AudioServer.set_bus_mute(MUSIC_BUS_ID, !toggled_on)
	Global.user_settings.set_music_mute(!toggled_on)

# Toggle sfx on/off
func _on_sfx_check_btn_toggled(toggled_on):
	AudioServer.set_bus_mute(SFX_BUS_ID, !toggled_on)
	Global.user_settings.set_sfx_mute(!toggled_on)
	
	
