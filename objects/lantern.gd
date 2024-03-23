extends PointLight2D

"""
Lantern that has a fuel level and illuminates in a circle around its center.

In order to control the speed at which the lantern burns its fuel, use the two 
export variables. For example, setting 'decrement per second' to 1 and 'updates
per second' to 4 will cause the lantern to lose 1 fuel point per second over 4 
intervals (the timer has a callback of 0.25 seconds).
"""

# Use these two export variables to determine how fast 
@export var decrement_per_second: float
@export var updates_per_second: int

signal fuel_level_changed(fuel_level: int)
signal fuel_exhausted()

@onready var timer = $Timer
#@onready var sprite =  $AnimatedSprite2D2

const MIN_FUEL_LEVEL: int = 0
const MAX_FUEL_LEVEL: int = 30
const START_FUEL_LEVEL: int = 10
const SCALE = 20.0

var on: bool = true
var fuel_level: float = 20
var decrement: bool = true

# Set correct timer wait time
func _ready() -> void:
	timer.set_wait_time(decrement_per_second/updates_per_second)

# Decrement the fuel level by 2 per second
func _on_timer_timeout() -> void:
	if decrement and fuel_level > MIN_FUEL_LEVEL:
		fuel_level -= 0.25
		set_texture_scale(fuel_level/SCALE)
		fuel_level_changed.emit(fuel_level)
	if fuel_level == MIN_FUEL_LEVEL:
		fuel_exhausted.emit()

# Increment the fuel level, signal sent from refill station
func increment_fuel() -> void:
	if fuel_level < MAX_FUEL_LEVEL:
		fuel_level += 1
		set_texture_scale(fuel_level/SCALE)
		fuel_level_changed.emit(fuel_level)

# Don't allow decrementing while refueling
func refueling_started() -> void:
	decrement = false

# Restart decrementing once done refueling
func refueling_stopped() -> void:
	decrement = true
	
