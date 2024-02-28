extends Node2D

"""
Menu script. Saves the protagonists position in the menu when a level is 
entered. Positions the protagonist in the correct position when the menu is 
reloaded.
"""

@export var protagonist: Protagonist

# Ready
func _ready():
	
	# Listen for entering level signal
	$EnterDali.entering_level.connect(save_pos)
	$EnterVanGogh.entering_level.connect(save_pos)
	$EnterEscher.entering_level.connect(save_pos)
	$EnterTutorial.entering_level.connect(save_pos)
	
	# Position the protagonist where they were in the menu
	protagonist.position = Global.menu_pos

# Save the big protagonist's position globally
func save_pos() -> void:
	Global.menu_pos = Global.protagonist.position
