extends Node2D

"""
Menu script. Saves the protagonists position in the menu when a level is 
entered. Positions the protagonist in the correct position when the menu is 
reloaded.
"""

@export var protagonist: Protagonist

# Ready
func _ready():
	
	# Save protag position in menu when entering new scene
	$EnterDali.entering_level.connect(save_pos)
	$EnterVanGogh.entering_level.connect(save_pos)
	$EnterEscher.entering_level.connect(save_pos)
	$EnterTutorial.entering_level.connect(save_pos)
	
	# Position the protagonist where they were in the menu
	protagonist.position = Global.menu_pos
	
	# Play panning animation on startup
	if Global.startup:
		protagonist.disable()
		Global.startup = false
		$PanningCamera.make_current()
		$AnimationPlayer.play("camera_pan")
	else:
		remove_child($AnimationPlayer)
		remove_child($PanningCamera)

# Save the big protagonist's position globally
func save_pos() -> void:
	Global.menu_pos = Global.protagonist.position

# Camera pan finished
func _on_animation_player_animation_finished(_anim_name):
	remove_child($AnimationPlayer)	
	remove_child($PanningCamera)
	protagonist.enable()
	
	
