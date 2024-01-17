extends Area2D

@export var gravity_dir = "down"
@export var id:int = -1
@export var enter: bool = true
@export var exit_id:int = -1
@export var x_offset = 0
@export var y_offset = 0

var lock_door = false

func _on_body_entered(body):
	if body.is_in_group("protagonist") && enter:
		teleport(body)

func lock():
	lock_door = true
	$Timer.start()

func teleport(body):
	for door in get_tree().get_nodes_in_group("door"):
		if door != self && door.id == exit_id: 
			if !door.lock_door:
				lock()
				body.global_position.x = door.global_position.x + door.x_offset
				body.global_position.y = door.global_position.y + door.y_offset
				
				body.set_gravity(door.gravity_dir)
			break


func _on_timer_timeout():
	lock_door = false
