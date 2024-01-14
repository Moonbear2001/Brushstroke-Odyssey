extends Node2D



func _on_quit_pressed():
	get_tree().quit()

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

