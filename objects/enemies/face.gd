extends Node2D

"""
Mario-style falling war face that crushes the protagonist. No weak area, 
cannot die.
"""

@onready var enemy = $Enemy

func _ready():
	enemy.attack = Callable(self, "attack")
	enemy.move = Callable(self, "move")
	$Enemy/AnimationPlayer.play("loop")

func attack(protagonist, direction):
	if protagonist.global_position.x < global_position.x:
		protagonist.throw(-1)
	else:
		protagonist.throw(1)
	protagonist.take_damage(5)

func move(delta):
	pass

func _on_timer_timeout():
	queue_free()
