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
const GRAV_LEFT = 2
const GRAV_RIGHT = 3


# Get the default gravity setting (980)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_orientation = GRAV_DOWN

var orientation = GRAV_DOWN


# Child nodes
@onready var camera = $Camera2D
@onready var sprite = $Sprite

# Not using atm
#var move_dir: Vector2

func _ready():
	pass

func _physics_process(delta):
	
	if not input_enabled:
		return
	
	if orientation == GRAV_DOWN:
		use_gravity_down(delta)
	elif orientation == GRAV_LEFT:
		use_gravity_left(delta)
	elif orientation == GRAV_RIGHT:
		use_gravity_right(delta)
	else:
		use_gravity_up(delta)
	
	## Add gravity
	#velocity.y += gravity * gravity_orientation * delta
#
	## Handle jump
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY * gravity_orientation * -1
#
	## Handle left and right movement
	#var direction = Input.get_axis("left", "right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

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
		

# Switches gravity, rotates the character model and changes the up direction
func use_gravity_left(delta):
	# Add gravity
	velocity.x += gravity * delta * -1

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_wall():
		velocity.x = JUMP_VELOCITY

	# Handle left and right movement
	var direction = Input.get_axis("right", "left")
	if direction:
		velocity.y = direction * SPEED * -1
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

func use_gravity_right(delta):
	# Add gravity
	velocity.x += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_wall():
		velocity.x = JUMP_VELOCITY * -1

	# Handle left and right movement
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

func use_gravity_down(delta):
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

func use_gravity_up(delta):
		# Add gravity
	velocity.y += gravity * -1 * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_ceiling():
		velocity.y = JUMP_VELOCITY

	# Handle left and right movement
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func set_gravity(direction):
	if direction.to_lower() == "down":
		orientation = GRAV_DOWN
		sprite.rotation_degrees = 0
	elif direction.to_lower() == "left":
		orientation = GRAV_LEFT
		sprite.rotation_degrees = 90
	elif direction.to_lower() == "right":
		orientation = GRAV_RIGHT
		sprite.rotation_degrees = 270
	else:
		orientation = GRAV_UP
		sprite.rotation_degrees = 180

# Disable visibility and controls
func disable():
	input_enabled = false
	visible = false

# Enable visibility and controls
func enable():
	input_enabled = true
	visible = true

