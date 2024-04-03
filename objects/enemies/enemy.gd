class_name Enemy
extends CharacterBody2D

@export var damage_area: Area2D
@export var weak_area: Area2D
@export var move_speed: int = 100
@export var use_gravity = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.LEFT  # Initial movement direction

var attack: Callable = func(body, direction):
	pass

# Let each enemy define its own idle animation/movement pattern
var idle: Callable = func(body, direction):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_area.connect("body_entered", Callable(self, "collide"))

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
	if use_gravity:
		velocity.y += gravity * delta
	move_and_slide()

func collide(body):
	if body.is_in_group("protagonist"):
		attack.call(body, direction)
	else:
		change_direction()
		
func add_gravity():
	use_gravity = true
