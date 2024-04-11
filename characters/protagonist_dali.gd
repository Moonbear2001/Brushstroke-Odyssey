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

