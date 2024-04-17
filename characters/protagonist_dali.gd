extends Protagonist

"""
Protagonist specific to the Dali level.
"""
signal fade_to_black

const THROW_VELOCITY = 200

var health = 2
var is_thrown = false
var throw_velocity = 200
var throw_direction = 1
var death_waiting = false
var dying = false

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
	
	if death_waiting and is_on_floor():
		death_waiting = false
		respawn()

# Add shadow jumping behavior
#func _physics_process(delta):
	#super._physics_process(delta)
	
	

func take_damage(amount, is_clock=false):
	if dying:
		return false
	if is_clock and health <= 1 and amount == 1:
		return false
	if health >= 5 and amount == -1:
		return false
	health -= amount
	distortion = 5 - health
	if health <= 0:
		death_waiting = true
	return true

func throw(direction):
	if dying:
		return
	throw_direction = direction
	velocity.y = -JUMP_VELOCITY
	throw_velocity = THROW_VELOCITY * direction
	velocity.x += throw_velocity
	is_thrown = true
	move_and_slide()

func get_anim_name(anim_name: String):
	if anim_name in ["CrouchLeft", "CrouchRight"]:
		return anim_name + "_Dali"
	return anim_name + "_Dali_" + str(distortion)
	
func respawn():
	dying = true
	disable_input()
	velocity = Vector2(0, 0)
	anim.play("Death_Dali")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Death_Dali":
		fade_to_black.emit()
