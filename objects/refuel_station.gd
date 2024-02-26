class_name RefuelStation
extends Node2D

"""
Refill station for a lantern.
"""

signal exit_station(exit_pos: Vector2)
signal refuel_area_entered()
signal refuel_area_exited()
signal increment_fuel_level()

@onready var anim_player = $AnimationPlayer
@onready var enter_station_area = $EnterStationArea
@onready var exit_station_area = $ExitStationArea
@onready var exit_pos = $ExitPos
@onready var timer = $Timer

# Play correct starting animation, hook up interactions
func _ready():
	anim_player.play("lit")
	enter_station_area.interact = Callable(self, "enter")
	exit_station_area.interact = Callable(self, "exit")

# Enter the refill station
func enter() -> void:
	anim_player.play("inside")
	var protagonist = get_tree().get_first_node_in_group("protagonist")
	protagonist.glow = false
	
# Exit the refill station
func exit() -> void:
	exit_station.emit(exit_pos)
	anim_player.play("lit")
	
# Protagonist entered the refill area
func _on_refill_area_body_entered(body):
	if body is Protagonist:
		refuel_area_entered.emit()
		body.refueling = true
		timer.start()
	
# Protagonist exited the refill area
func _on_refill_area_body_exited(body):
	if body is Protagonist:
		refuel_area_exited.emit()
		body.refueling = false
		timer.stop()

# Signal to increment how much fuel we have
func _on_timer_timeout():
	increment_fuel_level.emit()
