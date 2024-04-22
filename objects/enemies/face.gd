extends Enemy


"""
Mario-style falling war face that crushes the protagonist. No weak area, 
cannot die.
"""
@onready var anim = $AnimationPlayer

var dying: bool = false
var move_speed: int = 150

func _ready():
	super._ready()
	anim.play("idle")
	
	# Initial hitbox setup
	$Enemy/DamageArea/Frame0Hitbox.set_disabled(false)
	$Enemy/DamageArea/Frame1Hitbox.set_disabled(true)
	$Enemy/DamageArea/Frame2Hitbox.set_disabled(true)
	$Enemy/DamageArea/Frame3Hitbox.set_disabled(true)
	$Enemy/DamageArea/Frame4Hitbox.set_disabled(true)
	$Enemy/DamageArea/Frame5to6Hitbox.set_disabled(true)
	
	$Enemy.velocity = Vector2(0, 50)

	for hitbox in damage_back.get_children():
		hitbox.set_disabled(true)
	for hitbox in damage_front.get_children():
		hitbox.set_disabled(true)

func _process(delta):
	super._process(delta)
	velocity.y = move_speed
	if is_on_floor():
		death_process()
	move_and_slide()
	

func death_process():
	if not dying:
		$DequeueTimer.start()
		#if abs(Global.protagonist.global_position.x - global_position.x) < 700:
			#$Enemy/splat.play()
		$Enemy/AnimationPlayer.play("splat")
		dying = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "splat":
		queue_free()


# Protagonist entered a damage area
func _on_damage_area_body_entered(body):
	if body is Protagonist:
		#$Enemy/hit.play()
		body.throw(-1)
		body.take_damage(1)

func set_speed(speed):
	move_speed = speed
	
func increase_speed():
	move_speed += 50
	
func decrease_speed():
	move_speed -= 50

