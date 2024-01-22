class_name Protagonist
extends CharacterBody2D

"""
Main playable character.
"""

# Export variables
@export var input_enabled: bool = true

# Constants
const SPEED = 140.0
const JUMP_VELOCITY = 400.0
const GRAV_UP = -1
const GRAV_DOWN = 1
const GRAV_LEFT = 2
const GRAV_RIGHT = 3



# Get the default gravity setting (980)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_orientation = GRAV_DOWN


# Child nodes
@onready var camera = $Camera2D
@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

# Not using atm
#var move_dir: Vector2

func _ready():
	anim.play("Idle")

func _physics_process(delta):
	if not input_enabled:
		return
	
	if gravity_orientation == GRAV_DOWN:
		use_gravity_down(delta)
	elif gravity_orientation == GRAV_LEFT:
		use_gravity_left(delta)
	elif gravity_orientation == GRAV_RIGHT:
		use_gravity_right(delta)
	else:
		use_gravity_up(delta)

	move_and_slide()

# Handle input events, gets called before physics process
func _input(_input_event):
	
	if not input_enabled:
		return
	
	# Testing camera rotation (C)
	if Input.is_action_just_pressed("camera"):
		camera.rotation_degrees += 90
		
	# Gravity control (G)
	#if Input.is_action_just_pressed("gravity"):
		#rotate_180()
		
# Switches gravity, rotates the character model and changes the up direction
#func rotate_180():
	#gravity_orientation *= -1
	#
	## Option for the future: 'if you want all collisions to be reported as walls, 
	## consider using MOTION_MODE_FLOATING as motion_mode.' in CharacterBody2D docs
	#
	#if up_direction == Vector2.UP:
		#up_direction = Vector2.DOWN
	#else:
		#up_direction = Vector2.UP
#
	#if self.rotation_degrees == 0:
		#self.rotation_degrees = 180
	#else:
		#self.rotation_degrees = 0
		

# Switches gravity, rotates the character model and changes the up direction
func use_gravity_left(delta):
	# Add gravity
	if not is_on_floor():
		velocity.x += gravity * delta * -1
	else:
		velocity.x = 0

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.x = JUMP_VELOCITY
		
	if not is_on_floor():
		set_jump_animation()

	# Handle left and right movement
	var direction = Input.get_axis("right", "left")
	if direction:
		velocity.y = direction * SPEED * -1
		print(velocity.x)
		if velocity.x == 0:
			if direction < 0:
				anim.play("RunRight")
			else:
				anim.play("RunLeft")
	else:
		if velocity.x == 0:
			anim.play("Idle")
		velocity.y = move_toward(velocity.y, 0, SPEED)

func use_gravity_right(delta):
	# Add gravity
	if not is_on_floor():
		velocity.x += gravity * delta
	else:
		velocity.x = 0

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.x = JUMP_VELOCITY * -1
	
	if not is_on_floor():
		set_jump_animation()

	# Handle left and right movement
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.y = direction * SPEED
		if velocity.x == 0:
			if direction > 0:
				anim.play("RunRight")
			else:
				anim.play("RunLeft")
	else:
		if velocity.x == 0:
			anim.play("Idle")
		velocity.y = move_toward(velocity.y, 0, SPEED)

func use_gravity_down(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * -1
	
	if not is_on_floor():
		set_jump_animation()

	# Handle left and right movement
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			if direction > 0:
				anim.play("RunRight")
			else:
				anim.play("RunLeft")
	else:
		if velocity.y == 0:
			anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED) 

func use_gravity_up(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta * -1
	else:
		velocity.y = 0

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if not is_on_floor():
		set_jump_animation()

	# Handle left and right movement
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			if direction < 0:
				anim.play("RunRight")
			else:
				anim.play("RunLeft")
	else:
		if velocity.y == 0:
			anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

func set_gravity(direction):
	if direction.to_lower() == "down":
		up_direction = Vector2(0, -1)
		gravity_orientation = GRAV_DOWN
		rotate_protagonist(0)
	elif direction.to_lower() == "left":
		up_direction = Vector2(1, 0)
		gravity_orientation = GRAV_LEFT
		rotate_protagonist(90)
	elif direction.to_lower() == "right":
		up_direction = Vector2(-1, 0)
		gravity_orientation = GRAV_RIGHT
		rotate_protagonist(270)
	else:
		up_direction = Vector2(0, 1)
		gravity_orientation = GRAV_UP
		rotate_protagonist(180)


func rotate_protagonist(deg):
	sprite.rotation_degrees = deg
	collision_shape.rotation_degrees = deg

func set_jump_animation():
	if gravity_orientation == GRAV_DOWN:
		if velocity.x < 0:
			if velocity.y > -100 and velocity.y < 100:
				anim.play("CrouchLeft")
			elif velocity.y > 0:
				anim.play("FallLeft")
			elif velocity.y < 0:
				anim.play("JumpLeft")
		elif velocity.x > 0:
			if velocity.y > -100 and velocity.y < 100:
				anim.play("CrouchRight")
			elif velocity.y > 0:
				anim.play("FallRight")
			elif velocity.y < 0:
				anim.play("JumpRight")
		else:
			if velocity.y > -100 and velocity.y < 100:
				anim.play("CrouchRight")
			elif velocity.y > 0:
				anim.play("FallCenter")
			elif velocity.y < 0:
				anim.play("JumpCenter")
	elif gravity_orientation == GRAV_UP:
		if velocity.x > 0:
			if velocity.y > -100 and velocity.y < 100:
				anim.play("CrouchLeft")
			elif velocity.y < 0:
				anim.play("FallLeft")
			elif velocity.y > 0:
				anim.play("JumpLeft")
		elif velocity.x < 0:
			if velocity.y > -100 and velocity.y < 100:
				anim.play("CrouchRight")
			elif velocity.y < 0:
				anim.play("FallRight")
			elif velocity.y > 0:
				anim.play("JumpRight")
		else:
			if velocity.y > -100 and velocity.y < 100:
				anim.play("CrouchLeft")
			elif velocity.y > 0:
				anim.play("FallCenter")
			elif velocity.y < 0:
				anim.play("JumpCenter")
	elif gravity_orientation == GRAV_RIGHT:
		if velocity.y > 0:
			if velocity.x > -100 and velocity.x < 100:
				anim.play("CrouchLeft")
			elif velocity.x < 0:
				anim.play("FallLeft")
			elif velocity.x > 0:
				anim.play("JumpLeft")
		elif velocity.y < 0:
			if velocity.x > -100 and velocity.x < 100:
				anim.play("CrouchRight")
			elif velocity.x > 0:
				anim.play("FallRight")
			elif velocity.x < 0:
				anim.play("JumpRight")
		else:
			if velocity.x > -100 and velocity.x < 100:
				anim.play("CrouchLeft")
			elif velocity.x > 0:
				anim.play("FallCenter")
			elif velocity.x < 0:
				anim.play("JumpCenter")
	elif gravity_orientation == GRAV_LEFT:
		if velocity.y < 0:
			if velocity.x > -100 and velocity.x < 100:
				anim.play("CrouchLeft")
			elif velocity.x > 0:
				anim.play("JumpLeft")
			elif velocity.x < 0:
				anim.play("FallLeft")
		elif velocity.y > 0:
			if velocity.x > -100 and velocity.x < 100:
				anim.play("CrouchRight")
			elif velocity.x < 0:
				anim.play("FallRight")
			elif velocity.x > 0:
				anim.play("JumpRight")
		else:
			if velocity.x > -100 and velocity.x < 100:
				anim.play("CrouchRight")
			elif velocity.x > 0:
				anim.play("FallCenter")
			elif velocity.x < 0:
				anim.play("JumpCenter")
		

# Disable visibility and controls
func disable():
	input_enabled = false
	visible = false

# Enable visibility and controls
func enable():
	input_enabled = true
	visible = true

