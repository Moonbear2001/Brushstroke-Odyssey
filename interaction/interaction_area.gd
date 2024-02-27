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
@export var label_color: Color = Color(1, 1, 1)

# The parent shoule define a Node2D that is where it wants the InteractionManager
# to draw it's interaction label
@onready var label_pos: Node2D = $"../LabelPos"

var enabled = true

var interact: Callable = func():
	pass

func _on_area_entered(_area) -> void:
	InteractionManager.register_area(self)

func _on_area_exited(_area) -> void:
	InteractionManager.unregister_area(self)
