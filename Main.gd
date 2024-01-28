extends Node2D

"""
Main menu.
"""


func _on_quit_pressed():
	get_tree().quit()

func _on_tutorial_pressed():
	#get_tree().change_scene_to_file("res://levels/tutorial.tscn")
	SceneManager.load_new_scene("res://levels/tutorial.tscn")

func _on_level_1_pressed():
	#get_tree().change_scene_to_file("res://levels/escher.tscn")
	SceneManager.load_new_scene("res://levels/escher.tscn")

func _on_highscores_pressed():
	SceneManager.load_new_scene("res://levels/high_scores_page.tscn")
