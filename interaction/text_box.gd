extends MarginContainer

"""
"""

@onready var container: MarginContainer = $MarginContainer

var label: Label = null

func display_text(text_to_display: String):
	for child in container.get_children():
		container.remove_child(child)
	label = Label.new()
	container.add_child(label)
	label.set_text(text_to_display)
	label.add_theme_color_override("font_color", Color.BLACK)
