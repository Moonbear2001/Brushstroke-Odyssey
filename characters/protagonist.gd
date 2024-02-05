class_name Protagonist
extends CharacterBody2D

"""
Main playable character.
"""

# Export variables
@export var input_enabled: bool = true
@export var big = false

# Constants
var SPEED = 140.0
#const JUMP_VELOCITY = 400.0
# Temporarily increased jump velocity for passing level easier for demo!
const JUMP_VELOCITY = 520.0

# Get the default gravity setting (980)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var x_val = 0
var y_val = -1

# Child nodes
@onready var camera = $Camera2D
@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

# Not using atm
#var move_dir: Vector2

func _ready():
	if big:
		SPEED = 320
	anim.play("Idle")

func _physics_process(delta):
	if not input_enabled:
		return
	
	use_gravity(delta)

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
		

func use_gravity(delta):
	if x_val != 0:
		if not is_on_floor():
			velocity.x += gravity * delta * x_val * -1
		else:
			velocity.x = 0
	else:
		if not is_on_floor():
			velocity.y += gravity * delta * y_val * -1
		else:
			velocity.y = 0
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and not big:
		if x_val != 0:
			velocity.x = JUMP_VELOCITY * x_val
		else:
			velocity.y = JUMP_VELOCITY * y_val
	
	if not is_on_floor() and not big:
		set_jump_animation()
	
	var direction
	
	if x_val < 0 and y_val == 0:
		direction = Input.get_axis("right", "left")
	else:
		if x_val < 0 or y_val < 0:
			direction = Input.get_axis("left", "right")
		else:
			direction = Input.get_axis("right", "left")
	if direction:
		if x_val != 0:
			velocity.y = direction * SPEED * x_val * -1
			if velocity.x == 0:
				if direction < 0:
					anim.play("RunRight")
				else:
					anim.play("RunLeft")
		else:
			velocity.x = direction * SPEED * y_val * -1
			if velocity.y == 0:
				if direction > 0:
					anim.play("RunRight")
				else:
					anim.play("RunLeft")
	else:
		if x_val != 0:
			if velocity.x == 0:
				anim.play("Idle")
			velocity.y = move_toward(velocity.y, 0, SPEED)
		else:
			if velocity.y == 0:
				anim.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED) 

func set_gravity(direction):
	if direction.to_lower() == "down":
		up_direction = Vector2(0, -1)
		x_val = 0
		y_val = -1
		rotate_protagonist(0)
	elif direction.to_lower() == "left":
		up_direction = Vector2(1, 0)
		x_val = 1
		y_val = 0
		rotate_protagonist(90)
	elif direction.to_lower() == "right":
		up_direction = Vector2(-1, 0)
		x_val = -1
		y_val = 0
		rotate_protagonist(270)
	else:
		up_direction = Vector2(0, 1)
		x_val = 0
		y_val = 1
		rotate_protagonist(180)


func rotate_protagonist(deg):
	sprite.rotation_degrees = deg
	collision_shape.rotation_degrees = deg

func set_jump_animation():
	var v_jump
	var v_lat
	var dir

	if x_val != 0:
		v_jump = velocity.x
		v_lat = velocity.y
		dir = x_val
	else:
		v_jump = velocity.y
		v_lat = velocity.x * y_val * -1
		dir = y_val
	
	if x_val == -1 and y_val == 0:
		if v_lat > 0:
			if v_jump > -100 and v_jump  < 100:
				anim.play("CrouchLeft")
			elif v_jump > 0:
				anim.play("FallLeft")
			elif v_jump < 0:
				anim.play("JumpLeft")
		elif v_lat < 0:
			if v_jump > -100 and v_jump < 100:
				anim.play("CrouchRight")
			elif v_jump > 0:
				anim.play("FallRight")
			elif v_jump < 0:
				anim.play("JumpRight")
		else:
			if v_jump > -100 and v_jump < 100:
				anim.play("CrouchRight")
			elif v_jump > 0:
				anim.play("FallCenter")
			elif v_jump < 0:
				anim.play("JumpCenter")
	
	else:
		if v_lat < 0:
			if v_jump * dir * -1 > -100 and v_jump * dir * -1 < 100:
				anim.play("CrouchLeft")
			elif v_jump * dir * -1 > 0:
				anim.play("FallLeft")
			elif v_jump * dir * -1 < 0:
				anim.play("JumpLeft")
		elif v_lat > 0:
			if v_jump * dir * -1  > -100 and v_jump * dir * -1 < 100:
				anim.play("CrouchRight")
			elif v_jump * dir * -1 > 0:
				anim.play("FallRight")
			elif v_jump * dir * -1 < 0:
				anim.play("JumpRight")
		else:
			if v_jump > -100 and v_jump < 100:
				anim.play("CrouchRight")
			elif v_jump * dir * -1 > 0:
				anim.play("FallCenter")
			elif v_jump * dir * -1 < 0:
				anim.play("JumpCenter")

# Disable visibility and controls
func disable():
	input_enabled = false
	visible = false

# Enable visibility and controls
func enable():
	input_enabled = true
	visible = true

