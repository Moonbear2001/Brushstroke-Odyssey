extends Node2D
signal refuel_area_entered()
signal refuel_area_exited()
signal increment_fuel_level()

@onready var interaction_area = $InteractionArea
@onready var timer = $Timer

var refueling = false
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "refuel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("interact") and is_instance_valid(Global.protagonist):
		Global.protagonist.refueling_left = false
		Global.protagonist.refueling_right = false
		refuel_area_exited.emit()
		timer.stop()
		refueling = false
	elif refueling and Input.is_action_pressed("interact"):
		if timer.is_stopped():
			timer.start()

func refuel():
	if Input.is_action_pressed("interact"):
		refuel_area_entered.emit()
		if is_instance_valid(Global.protagonist) and global_position.x < Global.protagonist.global_position.x:
			Global.protagonist.refueling_left = true
		else:
			Global.protagonist.refueling_right = true
		refueling = true
		timer.start()
		

# Signal to increment how much fuel we have
func _on_timer_timeout():
	increment_fuel_level.emit()
