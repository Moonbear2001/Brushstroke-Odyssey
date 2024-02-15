extends Node2D

"""
Page for displaying high scores.
"""

@onready var label : Label = $Label2

# Ready
func _ready():
	var ret = Global.high_scores.get_high_scores_str()
	label.text = ret
