class_name Enemy
extends CharacterBody2D

"""
Base enemy class.
"""

@export var damage_area: Area2D
@export var weak_area: Area2D

var direction = Vector2.LEFT  # Initial movement direction

# Let each enemy define its own idle animation/movement pattern
func idle(_body, _direction):
	pass

func _ready():
	damage_area.connect("body_entered", Callable(self, "attack"))

func _process(_delta):
	pass

func change_direction():
	scale.x *= -1
	direction *= -1
	
func attack(body):
	if body.is_in_group("protagonist"):
		$hit.play()
		body.throw(direction.x)
		body.take_damage(1)
