class_name LevelUI
extends CanvasLayer

"""
User interface for each level. Displays current time and stars collected.
"""

@onready var ui_stars: Array[Node] 

var num_stars: int = 0

func _ready():
	
	# Play empty animation to start
	ui_stars =  $Stars.get_children()
	for star in ui_stars:
		star.play("empty")
	
	# Listen for stars being collected
	var level_stars = get_tree().get_nodes_in_group("star")
	for star in level_stars:
		star.collected.connect(star_collected)
		
	
func star_collected() -> void:
	print(num_stars)
	ui_stars[num_stars].play("full")
	num_stars += 1
	
