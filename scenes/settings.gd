extends Control

"""
Window for navigating to the menu, controlling volume, and resetting high scores.
"""

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var sfx_check = $CanvasLayer/SfxCheckBtn
@onready var node = $CanvasLayer/Node2D
@onready var canvas_layer = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	canvas_layer.hide()
		
# Open the settings page
func toggle_settings_window() -> void:
	if canvas_layer.visible:
		canvas_layer.hide()
	else:
		canvas_layer.show()
			
# Hide the settings sindow
func hide_settings_window() -> void:
	canvas_layer.hide()

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_menu_btn_pressed():
	SceneManager.load_new_scene(Global.MENU_PATH)

# Change music volume
func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < 0.05)

# Change sfx volume
func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < 0.05)

# Reset all scores
func _on_reset_scores_btn_pressed():
	Global.high_scores.reset_scores()

# Toggle music on/off
func _on_music_check_btn_toggled(toggled_on):
	if toggled_on:
		#AudioServer.set_bus_volume_db(MUSIC_BUS_ID, 0)
		AudioServer.set_bus_mute(MUSIC_BUS_ID, false)
	else:
		AudioServer.set_bus_mute(MUSIC_BUS_ID, true)

# Toggle sfx on/off
func _on_sfx_check_btn_toggled(toggled_on):
	if toggled_on:
		sfx_check.modulate = Color(239, 232, 223)
		AudioServer.set_bus_volume_db(SFX_BUS_ID, 0)
	else:
		AudioServer.set_bus_mute(SFX_BUS_ID, true)


func _on_restart_btn_pressed():
	get_tree().reload_current_scene()
	canvas_layer.hide()

func _on_close_btn_pressed():
	canvas_layer.hide()

