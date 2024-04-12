extends Protagonist

"""
Protagonist specific to the Dali level.
"""

var health = 2
var is_thrown = false
var throw_velocity = 400

func _ready():
	super._ready()

func _process(delta):
	if is_thrown and is_on_floor():
		is_thrown = false
	
	if is_thrown:
		velocity.x = throw_velocity

func take_damage(amount, is_clock=false):
	if is_clock and health <= 1 and amount == 1:
		return false
	if health >= 5 and amount == -1:
		return false
	health -= amount
	if health <= 0:
		pass
		#death
	return true

func throw(direction):
	velocity.y = -JUMP_VELOCITY
	throw_velocity = absi(throw_velocity) * direction
	velocity.x += throw_velocity
	is_thrown = true
	move_and_slide()
	
### GETTING REFLECTION WORKING ###
	
#func set_jump_animation():
	#var v_jump
	#var v_lat
	#var dir
#
	#if x_val != 0:
		#v_jump = velocity.x
		#v_lat = velocity.y
		#dir = x_val
	#else:
		#v_jump = velocity.y
		#v_lat = velocity.x * y_val * -1
		#dir = y_val
#
	#if v_lat < 0:
		#if v_jump * dir * -1 > -100 and v_jump * dir * -1 < 100:
			#anim.play(get_anim_name("CrouchLeft"))
		#elif v_jump * dir * -1 > 0:
			#anim.play(get_anim_name("FallLeft"))
		#elif v_jump * dir * -1 < 0:
			#anim.play(get_anim_name("JumpLeft"))
	#elif v_lat > 0:
		#if v_jump * dir * -1  > -100 and v_jump * dir * -1 < 100:
			#anim.play(get_anim_name("CrouchRight"))
		#elif v_jump * dir * -1 > 0:
			#anim.play(get_anim_name("FallRight"))
		#elif v_jump * dir * -1 < 0:
			#anim.play(get_anim_name("JumpRight"))
	#else:
		#if v_jump > -100 and v_jump < 100:
			#anim.play(get_anim_name("CrouchRight"))
		#elif v_jump * dir * -1 > 0:
			#anim.play(get_anim_name("FallCenter"))
		#elif v_jump * dir * -1 < 0:
			#anim.play(get_anim_name("JumpCenter"))
			#
#func use_gravity(delta):
	#if not is_on_floor():
		#velocity.y += gravity * delta * y_val * -1
	#else:
		#velocity.y = 0
#
	#if Input.is_action_just_pressed("jump") and (is_on_floor() or not coyote_time.is_stopped()) and not input_disabled:
		#velocity.y = JUMP_VELOCITY * y_val
	#
	#if not is_on_floor() and not Input.is_action_pressed("climb"):
		#set_jump_animation()
	#
	#if climb and Input.is_action_pressed("climb"):
		#velocity = climb_slope * SPEED
		#anim.play(get_anim_name("Climb"))
		#return
	#
	## Left and right movement and animations
	#var direction
	#direction = Input.get_axis("left", "right")
	#if not input_disabled:
		#if direction:
			#velocity.x = direction * SPEED * y_val * -1
			#if velocity.y == 0:
				#if direction > 0:
					#anim.play(get_anim_name("RunRight"))
				#else:
					#anim.play(get_anim_name("RunLeft"))
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED) 
			#if velocity.y == 0:
				#anim.play(get_anim_name("Idle"))
	#elif velocity.y == 0:
			#anim.play(get_anim_name("Idle"))

