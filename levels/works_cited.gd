extends Node2D

"""
Worked cited page that lists all used borrowed assets. All the info is read
from the works_cited.txt file in the top-level directory.
"""

const wc_path = "res://works_cited.txt"

# Load in and read works cited file, set as label
func _ready():
	var file = FileAccess.open("res://works_cited.txt", FileAccess.READ)
	var text = file.get_as_text()
	$Label.set_text(text)
