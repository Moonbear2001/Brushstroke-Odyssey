extends Node2D

"""
Van Gogh level swaying tree.
"""

@onready var tree = $AnimatedSprite2D

func sway():
	if tree.is_playing():
		tree.stop()
	tree.play("swaying")
