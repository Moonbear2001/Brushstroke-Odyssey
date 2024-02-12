class_name InteractionArea
extends Area2D

"""
Interaction area that is capable of monitoring a region of space and then 
registering itself with the InteractionManager when something enters it.
When added to an object, the collision shape for that object is defined by 
adding a CollisionShape2D as a child node in that scene.
"""

@export var action_name: String = "interact"
@export var key: String = "E"
@export var label_color = Color(1, 1, 1)
var position_x = 0
var position_y = 0

@onready var overlay = $Overlay

var enabled = true

var interact: Callable = func():
	pass

var onEnter: Callable = func():
	pass

var onLeave: Callable = func():
	pass

func _on_area_entered(_area):
	InteractionManager.register_area(self)

func _on_area_exited(_area):
	InteractionManager.unregister_area(self)
