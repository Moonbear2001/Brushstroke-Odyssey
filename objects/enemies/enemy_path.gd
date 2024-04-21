extends PathFollow2D

"""

"""

@export var move_speed = 100

@onready var enemy = $Enemy

var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_instance_valid(enemy):
		queue_free()
	
	progress += move_speed * delta * direction
	
	if progress_ratio >= 1 or progress_ratio <= 0:
		direction *= -1
		enemy.change_direction()

func increase_speed():
	move_speed += 20

func decrease_speed():
	move_speed -= 20
