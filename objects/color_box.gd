extends StaticBody2D

"""
Interactable object built for testing the interaction system. Changes color 
randomly when interacted with.
"""

@onready var interaction_area = $InteractionArea
@onready var rng = RandomNumberGenerator.new()

func _ready():
	interaction_area.interact = Callable(self, "change_color")

# Change color when interacted with
func change_color():
	var r = rng.randf_range(0, 1)
	var g = rng.randf_range(0, 1)
	var b = rng.randf_range(0, 1)
	$Polygon2D.color = Color(r, g, b)
