extends Node2D

"""
Menu script.
"""

@onready var sound_pool = $SoundPool

# Ready
func _ready():
	
	# Play random ambience music 
	sound_pool.play_random_sound()

# View high scores pages
func open_hs_scene() -> void:
	SceneManager.load_new_scene(Global.LEVELS_PATH + "high_scores_page.tscn")
