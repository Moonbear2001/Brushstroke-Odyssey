extends Control

"""
Fuel bar that appears in the UI indicating how much fuel for the lantern is left.
"""

@onready var progress_bar = $ProgressBar
var fuel_lvl = 0

func _ready():
	progress_bar.set_value(progress_bar.min_value)

func _on_lantern_fuel_level_changed(fuel_level):
	progress_bar.value = fuel_level
	fuel_lvl = fuel_level
