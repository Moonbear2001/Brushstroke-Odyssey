extends Level

@onready var camera = $PlayerUI/Camera2D

"""
Top level script for the tutorial level.
"""

# Ready
func _ready():
	pass

func _process(delta):
	camera.position = protagonist.position
