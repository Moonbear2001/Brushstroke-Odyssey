extends Node2D

"""
Menu script.
"""

@onready var sound_pool = $SoundPool
@onready var protagonist = get_tree().get_first_node_in_group("big protagonist")

# Ready
func _ready():
	
	# Play random ambience music 
	sound_pool.play_random_sound()
	
	# Listen for entering level signal
	$EnterDali.entering_level.connect(save_pos)
	$EnterVanGogh.entering_level.connect(save_pos)
	$EnterEscher.entering_level.connect(save_pos)
	$EnterTutorial.entering_level.connect(save_pos)
	
	# Position the protagonist
	protagonist.position = Global.menu_pos
	
# Save the big protagonist's position globally
func save_pos() -> void:
	Global.menu_pos = protagonist.position
	
