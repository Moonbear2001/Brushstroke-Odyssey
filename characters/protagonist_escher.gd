extends Protagonist

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
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if x_val != 0:
			velocity.x = JUMP_VELOCITY * x_val
		else:
			velocity.y = JUMP_VELOCITY * y_val
	
	if not is_on_floor() and not Input.is_action_pressed("climb"):
		set_jump_animation()
	
	if Input.is_action_pressed("climb") and climb:
		velocity = Vector2(0, -SPEED)
		anim.play(get_anim_name("Climb"))
	
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
					anim.play(get_anim_name("RunRight"))
				else:
					anim.play(get_anim_name("RunLeft"))
		else:
			velocity.x = direction * SPEED * y_val * -1
			if velocity.y == 0:
				if direction > 0:
					anim.play(get_anim_name("RunRight"))
				else:
					anim.play(get_anim_name("RunLeft"))
	else:
		if x_val != 0:
			if velocity.x == 0:
				var anim_name = get_anim_name("Idle")
				if anim_name:
					anim.play(anim_name)
			velocity.y = move_toward(velocity.y, 0, SPEED)
		else:
			if velocity.y == 0:
				var anim_name = get_anim_name("Idle")
				if anim_name:
					anim.play(anim_name)
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
				anim.play(get_anim_name("CrouchLeft"))
			elif v_jump > 0:
				anim.play(get_anim_name("FallLeft"))
			elif v_jump < 0:
				anim.play(get_anim_name("JumpLeft"))
		elif v_lat < 0:
			if v_jump > -100 and v_jump < 100:
				anim.play(get_anim_name("CrouchRight"))
			elif v_jump > 0:
				anim.play(get_anim_name("FallRight"))
			elif v_jump < 0:
				anim.play(get_anim_name("JumpRight"))
		else:
			if v_jump > -100 and v_jump < 100:
				anim.play(get_anim_name("CrouchRight"))
			elif v_jump > 0:
				anim.play(get_anim_name("FallCenter"))
			elif v_jump < 0:
				anim.play(get_anim_name("JumpCenter"))
	
	else:
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
