extends Node2D

"""
Basically a ladder. 
Sends a signal when the protagonist reaches the top. Catch this signal somewhere 
else in the scene to make something happens when the protag finishes climbing.
"""

signal top_reached()

#func _on_area_2d_body_entered(body):
	##if body.is_in_group("protagonist"):
		##print("setting climb true")
		##body.climb = true
	#print("body entered")
	#if body is Protagonist:
		#print("setting climb true")
		#body.climb = true

#func _on_area_2d_body_exited(body):
	##if body.is_in_group("protagonist"):
		##print("setting climb false")
		##body.climb = false
	#if body is Protagonist:
		#print("setting climb false")
		#body.climb = false


#func _on_interaction_area_body_entered(body):
	#print("body entered")
	#if body is Protagonist:
		#print("setting climb false")
		#Global.protagonist.climb = true
#
#
#func _on_interaction_area_body_exited(body):
	#print("body exited")
	#if body is Protagonist:
		#print("setting climb true")
		#Global.protagonist.climb = false


#func _on_interaction_area_area_entered(area):
	#if area.is_in_group("protagonistArea"):
		#Global.protagonist.climb = true
#
#func _on_interaction_area_area_exited(area):
	#if area.is_in_group("protagonistArea"):
		#Global.protagonist.climb = false

# Got to top of ladder
func _on_top_body_entered(body):
	if body.is_in_group("protagonist") and Input.is_action_pressed("climb"):
		top_reached.emit()


func _on_body_entered(body):
	if body.is_in_group("protagonist"):
		body.climb = true


func _on_body_exited(body):
	if body.is_in_group("protagonist"):
		body.climb = false
