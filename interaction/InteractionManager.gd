extends Node2D

"""
Manages all the Interaction Areas. Is responsible for rendering the "interact" 
text above the object that is closest to the player and calling the method 
associated with that object if the protagonist uses "interact".
"""

@onready var protagonist = get_tree().get_first_node_in_group("protagonist")
@onready var label = $Label

const base_text = "[E] "
const enter_text = "[ENTER] "

# Holds all interaction areas that can currently be
# interacted with
var active_areas = []

var can_interact = true

# Register an area
func register_area(area: InteractionArea):
	active_areas.push_back(area)

# Unregister an area, if it is in the active areas
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas[index].onLeave.call()
		active_areas.remove_at(index)
		
func _process(_delta):
	# Show label based on closest interactable
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(sort_by_distance_to_player)
		if not active_areas[0].enabled:
			label.hide()
			return
		if active_areas[0].key == "E":
			label.text = base_text
		else:
			label.text = enter_text
		
		label.text += active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		
		label.global_position.y += active_areas[0].position_y
		label.global_position.x += active_areas[0].position_x
		label.modulate = active_areas[0].label_color
		active_areas[0].onEnter.call()
		label.show()
	elif active_areas.size() > 0:
		active_areas[0].onEnter.call()
	else:
		label.hide()

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
			label.hide()
			
			# Call the custom interaction function for the closest interactable
			await active_areas[0].interact.call()
			
			can_interact = true
