class_name Stopwatch
extends Node2D

"""
Stopwatch for keeping track of time spent doing each level.
"""

# The interval in which the stopwatch counts
@export var update_interval: float

@onready var update_timer = $UpdateTimer
@onready var label = $PanelContainer/Label

var elapsed_time : float
var running : bool 

# Ready
func _ready():
	
	elapsed_time = 0.0
	running = false
	update_timer.wait_time = update_interval
	
	# Testing
	start_stopwatch()
	
# Start the stopwatch
func start_stopwatch() -> void:
	running = true
	update_timer.start()

# Stop the stopwatch
func stop_stopwatch() -> void:
	running = false
	update_timer.stop()

# Reset the stopwatch
func reset_stopwatch() -> void:
	running = false
	elapsed_time = 0.0
	update_label()

# Return the current time
func get_best_time() -> float:
	return elapsed_time

func _on_update_timer_timeout() -> void:
	if running:
		elapsed_time += update_interval
		update_label()

# Update the label
func update_label() -> void:
	label.text = str(elapsed_time).pad_decimals(2)

