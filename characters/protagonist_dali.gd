extends Protagonist

var health = 3
var is_thrown = false
var throw_velocity = 400


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_thrown and is_on_floor():
		is_thrown = false
	
	if is_thrown:
		velocity.x = throw_velocity

func take_damage():
	health -= 1
	if health == 0:
		pass
		#DEATH

func throw(direction):
	velocity.y = -JUMP_VELOCITY
	throw_velocity = absi(throw_velocity) * direction
	velocity.x += throw_velocity
	is_thrown = true
	move_and_slide()

