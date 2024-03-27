class_name Enemy
extends CharacterBody2D

@export var collision_area: Area2D
var speed = 100  # Adjust as needed
var direction = Vector2.LEFT  # Initial movement direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)

func change_direction():
	scale.x *= -1
	direction.x *= -1
	# acts as an offset so that when the enemy flips, the tail end does not collide with the barrier again 
	# and trigger body_entered again
	global_position.x += 25 * direction.x
	
func move(delta):
	velocity.x = direction.x * speed
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("protagonist"):
		body.throw(direction.x)
		body.take_damage()
	else:
		change_direction()
