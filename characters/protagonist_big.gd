extends Protagonist

"""
Simple, big version of the protagonist for walking around the menu.
"""

func _ready():
	SPEED = 400

func use_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * y_val * -1
	else:
		velocity.y = 0
	
	var direction
	direction = Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED * y_val * -1
		if velocity.y == 0:
			if direction > 0:
				anim.play(get_anim_name("RunRight"))
			else:
				anim.play(get_anim_name("RunLeft"))
	else:
		if velocity.y == 0:
			var anim_name = get_anim_name("Idle")
			if anim_name:
				anim.play(anim_name)
		velocity.x = move_toward(velocity.x, 0, SPEED) 
