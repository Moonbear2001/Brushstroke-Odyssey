class_name Enemy
extends CharacterBody2D

@export var collision_area: Area2D
@export var move_speed: int = 100
var direction = Vector2.LEFT  # Initial movement direction

var attack: Callable = func(body, direction):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_area.connect("body_entered", Callable(self, "collide"))

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
	velocity.x = direction.x * move_speed
	move_and_slide()

func collide(body):
	if body.is_in_group("protagonist"):
		attack.call(body, direction)
	else:
		change_direction()
