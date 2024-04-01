extends Node2D

"""
An interactable area that takes the player into a new level.
"""

signal entering_level()

@export var level_name: String

@onready var interaction_area = $InteractionArea
@onready var overlay = $Overlay

func _ready():
	interaction_area.interact = Callable(self, "enter_level")

func enter_level():
	if level_name:
		entering_level.emit()
		SceneManager.load_new_scene(Global.LEVELS_PATH + level_name + ".tscn")

func _on_interaction_area_area_entered(_area):
	overlay.hide()

func _on_interaction_area_area_exited(_area):
	overlay.show()
