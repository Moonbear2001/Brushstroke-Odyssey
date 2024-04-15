extends Node2D

"""
Mario-style falling war face that crushes the protagonist. No weak area, 
cannot die.
"""

@onready var enemy = $Enemy

var dying: bool = false

func _ready():
	#enemy.attack = Callable(self, "attack")
	#enemy.move = Callable(self, "move")
	$Enemy/AnimationPlayer.play("idle")
	
	# Initial hitbox setup
	$Enemy/DamageArea/Frame0Hitbox.set_disabled(false)
	$Enemy/DamageArea/Frame1Hitbox.set_disabled(true)
	$Enemy/DamageArea/Frame2Hitbox.set_disabled(true)
	$Enemy/DamageArea/Frame3Hitbox.set_disabled(true)
	$Enemy/DamageArea/Frame4Hitbox.set_disabled(true)
	$Enemy/DamageArea/Frame5to6Hitbox.set_disabled(true)
	
	$Enemy.velocity = Vector2(0, 50)

func _process(_delta):
	enemy.move_and_slide()
	if enemy.is_on_floor():
		death_process()

#func attack(protagonist, direction):
	#if protagonist.global_position.x < global_position.x:
		#protagonist.throw(-1)
	#else:
		#protagonist.throw(1)
	#protagonist.take_damage(5)

#func _on_timer_timeout():
	#queue_free()

func death_process():
	if not dying:
		$DequeueTimer.start()
		$Enemy/AnimationPlayer.play("splat")
		dying = true

func _on_dequeue_timer_timeout():
	queue_free()

## Landed on tree branch
#func _on_damage_area_area_entered(area):
	#print("landed")

# Protagonist entered a damage area
func _on_damage_area_body_entered(body):
	if body is Protagonist:
		body.throw(-1)
		body.take_damage(1)
