class_name RefuelStation
extends Node2D

"""
Refill station for a lantern.
"""

signal exit_station(exit_pos: Vector2)
signal refuel_area_entered
signal refuel_area_exited

@onready var anim_player = $AnimationPlayer
@onready var enter_station_area = $Enter/EnterStationArea
@onready var refuel_light = $RefuelLight
@onready var checkpoint_pos = $Checkpoint
@onready var climb = $Climb

var visited = false
# Play correct starting animation, hook up interactions
func _ready():
	anim_player.play("lit")
	enter_station_area.interact = Callable(self, "enter")
	climb.top_reached.connect(exit)
	climb.disable()

# Enter the refill station
func enter() -> void:
	anim_player.play("inside")
	visited = true
	climb.enable()
	refuel_area_entered.emit()
	
# Exit the refill station
func exit() -> void:
	exit_station.emit()
	anim_player.play("lit")
	climb.disable()
	refuel_area_exited.emit()
