extends Control

"""
Window for controlling games settings.
"""

@onready var window = $Window

# Called when the node enters the scene tree for the first time.
func _ready():
	window.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("settings"):
		window.popup()
		window.move_to_center()
		
func _on_window_close_requested():
	window.hide()

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_menu_btn_pressed():
	SceneManager.load_new_scene(Global.MENU_PATH)
	
	
"""
Volume control.
Two sliders to adjust the volume, completely mutes the bus below a certain 
threshold
"""
	
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < 0.05)

func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < 0.05)
