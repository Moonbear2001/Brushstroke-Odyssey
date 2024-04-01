extends Node2D

signal increment_fuel_level()

@onready var interaction_area = $InteractionArea
@onready var timer = $Timer

var refueling = false

func _ready():
	interaction_area.interact = Callable(self, "refuel")

func _process(_delta):
	if Input.is_action_just_released("interact") and is_instance_valid(Global.protagonist):
		Global.protagonist.refueling_left = false
		Global.protagonist.refueling_right = false
		timer.stop()
		refueling = false
		Global.protagonist.enable_input()
	elif refueling and Input.is_action_pressed("interact"):
		if timer.is_stopped():
			timer.start()
		Global.protagonist.disable_input()
		Global.protagonist.velocity = Vector2(0, 0)

func refuel():
	if Input.is_action_pressed("interact"):
		if is_instance_valid(Global.protagonist) and global_position.x < Global.protagonist.global_position.x:
			Global.protagonist.refueling_left = true
		else:
			Global.protagonist.refueling_right = true
		refueling = true
		timer.start()


# Signal to increment how much fuel we have
func _on_timer_timeout():
	increment_fuel_level.emit()
