extends Level

"""
Custom level script or the Van Gogh level.
"""

@export var lantern: PointLight2D
@export var fuel_bar: Control
@export var refill_stations: Node2D

func _ready():
	
	# Call the base level script's _ready()
	super._ready()
	
	# Hook up the refill station's signals here because its a pain to do it
	# one by one in the Godot editor (also not good design)
	for refill_station in refill_stations.get_children():
		refill_station.increment_fuel_level.connect(lantern.increment_fuel)
		refill_station.refuel_area_entered.connect(lantern.refueling_started)
		refill_station.refuel_area_exited.connect(lantern.refueling_stopped)
		refill_station.exit_station.connect(on_refill_station_exited)
		

# Call the base level script's _process()
func _process(delta):
		super._process(delta)

# When exiting refill station, put protag back on top of station
func on_refill_station_exited(exit_pos):
	protagonist.global_position = exit_pos.get_global_position()

# Reload the level when fuel is exhausted
func _on_lantern_fuel_exhausted():
	get_tree().reload_current_scene()
