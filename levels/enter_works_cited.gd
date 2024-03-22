extends Node2D

"""
Same as enter level, but in works cited case there is no need to highlight the 
painting or track level name.
"""

signal entering_works_cited()

@export var level_name: String

func _ready():
	$InteractionArea.interact = Callable(self, "enter_works_cited")

func enter_works_cited():
	entering_works_cited.emit()
	SceneManager.load_new_scene("res://levels/works_cited.tscn")
