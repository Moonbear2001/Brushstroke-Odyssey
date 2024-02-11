extends Control
@onready var window = $Window

# Called when the node enters the scene tree for the first time.
func _ready():
	window.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("settings"):
		window.popup()
		window.move_to_center()
		
func _on_window_close_requested():
	window.hide()

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_menu_btn_pressed():
	SceneManager.load_new_scene("res://levels/menu.tscn")
