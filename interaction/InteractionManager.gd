extends Node2D

"""
Manages all the Interaction Areas. Is responsible for rendering the "interact" 
text above the object that is closest to the player and calling the method 
associated with that object if the protagonist uses "interact".
"""

@onready var protagonist = get_tree().get_first_node_in_group("protagonist")

const base_text = "[E] "

var text_box_scene: PackedScene = preload("res://interaction/text_box.tscn")
var text_box = text_box_scene.instantiate()

# Holds all interaction areas
var active_areas = []

# Whether there was a change in the 
var change: bool = true
var can_interact = true

func _ready():
	set_scale(Vector2(0.5, 0.5))
	add_child(text_box)
	
func make_new_text_box() -> void:
	remove_child(text_box)
	text_box = text_box_scene.instantiate()
	add_child(text_box)

# Register an area
func register_area(area: InteractionArea):
	active_areas.push_back(area)
	change = true

# Unregister an area, if it is in the active areas
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
	change = true

func _process(_delta):
	
	# If interaction isn't allowed or there has been on change, dont bother
	if !can_interact or !change:
		return
		
	# There's been a change in the available interaction areas
	change = false
	make_new_text_box()
	if active_areas.size() > 0:
		active_areas.sort_custom(sort_by_distance_to_player)
		if !active_areas[0].enabled:
			text_box.hide()
			return
		text_box.display_text("[" + active_areas[0].key + "] " + active_areas[0].action_name)
		text_box.global_position = active_areas[0].label_pos.global_position
		text_box.show()
	
	# Hide new text_box
	else:
		text_box.hide()

# Custom sorting function for active areas to determine closest interactable
# to the player
func sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea):

	# Check if both areas are enabled
	if area1.enabled and area2.enabled:
		
		# When a new scene is loaded, this object's reference to "protagonist" can
		# be lost, make sure that we get protagonist again to prevent an error
		# TODO: fix this! horrible design (maybe protagonist should be gobal (ie. Global.protagonist? maybe
		# when scenes change we refresh the reference?
		if protagonist == null:
			protagonist = get_tree().get_first_node_in_group("protagonist")
		
		# Calculate distances
		var area1_to_player = protagonist.global_position.distance_to(area1.global_position)
		var area2_to_player = protagonist.global_position.distance_to(area2.global_position)

		# Compare distances and return the result
		return area1_to_player < area2_to_player

	# If only one area is enabled, prioritize it
	return area1.enabled
	
	 
func _input(event):
	
	# Interact with the interactable
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			
			text_box.hide()
			
			# Call the custom interaction function for the closest interactable
			await active_areas[0].interact.call()
			
			can_interact = true
