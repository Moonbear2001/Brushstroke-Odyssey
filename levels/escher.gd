extends Node2D

"""
Top level script for the Escher level.
"""

@onready var camera = $PlayerUI/Camera2D
@onready var protagonist = $Protagonist

# Ready
func _ready():
	print("hello1")
	pass
#
func _process(delta):
	print("hello")
