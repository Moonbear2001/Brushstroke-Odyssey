extends Node2D

@onready var interaction_area = $InteractionArea
@onready var overlay = $InteractionArea/Overlay
@export var level_path: String

# Set to neutral and enabled by default
func _ready():
	interaction_area.interact = Callable(self, "enter_level")
	overlay.hide()

func enter_level():
	if level_path:
		SceneManager.load_new_scene(level_path)
