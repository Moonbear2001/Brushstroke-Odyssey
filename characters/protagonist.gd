class_name Protagonist
extends CharacterBody2D

"""
Main playable character.
"""

# Export variables
@export var enabled: bool = true
var input_disabled = false

# Constants
var SPEED = 140.0
#const JUMP_VELOCITY = 400.0
# Temporarily increased jump velocity for passing level easier for demo!
const JUMP_VELOCITY = 430.0

# Get the default gravity setting (980)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var x_val = 0
var y_val = -1
var climb = false
var coyote_time = Timer.new()

# Describes the angle at which the protag climbs when on a ladder
var climb_slope = Vector2(0, 0)

# Child nodes
@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D


func _ready():
	anim.play(get_anim_name("Idle"))
	coyote_time.wait_time = .15
	coyote_time.one_shot = true
	add_child(coyote_time)

func _physics_process(delta):
	if not enabled:
		return
	use_gravity(delta)
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor and not is_on_floor():
		coyote_time.start()


# Handle input events, gets called before physics process
func _input(_s):
	if not enabled or input_disabled:
		return

func use_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * y_val * -1
	else:
		velocity.y = 0

	if Input.is_action_just_pressed("jump") and (is_on_floor() or not coyote_time.is_stopped()) and not input_disabled:
		velocity.y = JUMP_VELOCITY * y_val
	
	if not is_on_floor() and not Input.is_action_pressed("climb"):
		set_jump_animation()
	
	if climb and Input.is_action_pressed("climb"):
		#velocity = Vector2(0, -SPEED)
		velocity = climb_slope * SPEED
		anim.play(get_anim_name("Climb"))
		return
	
	# Left and right movement and animations
	var direction
	direction = Input.get_axis("left", "right")
	if not input_disabled:
		if direction:
			velocity.x = direction * SPEED * y_val * -1
			if velocity.y == 0:
				if direction > 0:
					anim.play(get_anim_name("RunRight"))
				else:
					anim.play(get_anim_name("RunLeft"))
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED) 
			if velocity.y == 0 and not input_disabled:
				anim.play(get_anim_name("Idle"))
	elif velocity.y == 0 and not input_disabled:
			anim.play(get_anim_name("Idle"))

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

	if v_lat < 0:
		if v_jump * dir * -1 > -100 and v_jump * dir * -1 < 100:
			anim.play(get_anim_name("CrouchLeft"))
		elif v_jump * dir * -1 > 0:
			anim.play(get_anim_name("FallLeft"))
		elif v_jump * dir * -1 < 0:
			anim.play(get_anim_name("JumpLeft"))
	elif v_lat > 0:
		if v_jump * dir * -1  > -100 and v_jump * dir * -1 < 100:
			anim.play(get_anim_name("CrouchRight"))
		elif v_jump * dir * -1 > 0:
			anim.play(get_anim_name("FallRight"))
		elif v_jump * dir * -1 < 0:
			anim.play(get_anim_name("JumpRight"))
	else:
		if v_jump > -100 and v_jump < 100:
			anim.play(get_anim_name("CrouchRight"))
		elif v_jump * dir * -1 > 0:
			anim.play(get_anim_name("FallCenter"))
		elif v_jump * dir * -1 < 0:
			anim.play(get_anim_name("JumpCenter"))

# Disable visibility and controls and movement
func disable():
	enabled = false

# Enable visibility and controls
func enable():
	enabled = true

func disable_input():
	input_disabled = true

func enable_input():
	input_disabled = false

@warning_ignore("shadowed_variable_base_class")
func get_anim_name(name: String):
	return  name + "_default"


