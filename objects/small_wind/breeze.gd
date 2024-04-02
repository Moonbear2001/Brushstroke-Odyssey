extends Node2D
signal breeze_finished

"""
Van Gogh level breeze.
"""

func _on_animation_player_animation_finished(_anim_name):
	breeze_finished.emit()
	queue_free()
