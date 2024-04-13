extends Protagonist

"""
Protagonist specific to the Dali level.
"""

const THROW_VELOCITY = 200

var health = 2
var is_thrown = false
var throw_velocity = 200
var throw_direction = 1

# Currently the distortion level is increased when the character takes damage,
# but distortion and health are separate
var distortion: int = 3

func _ready():
	super._ready()

func _process(_delta):
	if is_thrown and is_on_floor():
		is_thrown = false
		input_disabled = false
	
	if is_thrown:
		velocity.x = throw_velocity
		if throw_direction != 0:
			input_disabled = true

func take_damage(amount, is_clock=false):
	if is_clock and health <= 1 and amount == 1:
		return false
	if health >= 5 and amount == -1:
		return false
	health -= amount
	distortion = 5 - health
	if health <= 0:
		respawn()
	return true

func throw(direction):
	throw_direction = direction
	velocity.y = -JUMP_VELOCITY
	throw_velocity = THROW_VELOCITY * direction
	velocity.x += throw_velocity
	is_thrown = true
	move_and_slide()

func get_anim_name(anim_name: String):
	if anim_name in ["Climb", "CrouchLeft", "CrouchRight"]:
		return anim_name + "_Dali"
	return anim_name + "_Dali_" + str(distortion)
	
func respawn():
	get_tree().reload_current_scene()
