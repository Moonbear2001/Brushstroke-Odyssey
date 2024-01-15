class_name Protagonist
extends CharacterBody2D

"""
Main playable character.
"""

# Export variables
@export var input_enabled: bool = true

# Constants
const SPEED = 300.0
const JUMP_VELOCITY = 400.0
const GRAV_UP = -1
const GRAV_DOWN = 1

# Get the default gravity setting (980)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_orientation = GRAV_DOWN

# Child nodes
@onready var camera = $Camera2D
@onready var sprite = $Sprite

# Not using atm
var move_dir: Vector2

func _ready():
	pass

func _physics_process(delta):
	
	if not input_enabled:
		return
	
	# Add gravity
	velocity.y += gravity * gravity_orientation * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * gravity_orientation * -1

	# Handle left and right movement
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Handle input events, gets called before physics process
func _input(input_event):
	
	if not input_enabled:
		return
	
	# Testing camera rotation (C)
	if Input.is_action_just_pressed("camera"):
		camera.rotation_degrees += 90
		
	# Gravity control (G)
	if Input.is_action_just_pressed("gravity"):
		rotate_180()
		
# Switches gravity, rotates the character model and changes the up direction
func rotate_180():
	gravity_orientation *= -1
	
	# Option for the future: 'if you want all collisions to be reported as walls, 
	# consider using MOTION_MODE_FLOATING as motion_mode.' in CharacterBody2D docs
	
	if up_direction == Vector2.UP:
		up_direction = Vector2.DOWN
	else:
		up_direction = Vector2.UP

	if sprite.rotation_degrees == 0:
		sprite.rotation_degrees = 180
	else:
		sprite.rotation_degrees = 0

# Disable visibility and controls
func disable():
	input_enabled = false
	visible = false

# Enable visibility and controls
func enable():
	input_enabled = true
	visible = true
