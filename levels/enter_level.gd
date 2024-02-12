extends Node2D

"""
An interactable area that takes the player into a new level when interacted 
with.
"""

@onready var interaction_area = $InteractionArea
@onready var overlay = $Overlay

@export var level_name: String
@export var label_x: int = 0
@export var label_y: int = 0
@export var color = Color(1, 1, 1)

# Set to neutral and enabled by default
func _ready():
	interaction_area.interact = Callable(self, "enter_level")
	interaction_area.onEnter = Callable(self, "hide_overlay")
	interaction_area.onLeave = Callable(self, "show_overlay")
	interaction_area.position_x = label_x
	interaction_area.position_y = label_y
	interaction_area.label_color = color

func show_overlay():
	overlay.show()

func hide_overlay():
	overlay.hide()

func enter_level():
	if level_name:
		SceneManager.load_new_scene(Global.LEVELS_PATH + level_name + ".tscn")
