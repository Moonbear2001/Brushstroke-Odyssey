extends Node2D

"""
Menu script.
"""

@onready var view_hs = $ViewHighScores
@onready var sound_pool = $SoundPool

# Ready
func _ready():
	
	# Set up interaction
	view_hs.enabled = true
	view_hs.interact = Callable(self, "open_hs_scene")
	
	# Play random ambience music 
	sound_pool.play_random_sound()

# View high scores pages
func open_hs_scene() -> void:
	SceneManager.load_new_scene("res://levels/high_scores_page.tscn")
