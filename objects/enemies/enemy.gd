class_name Enemy
extends CharacterBody2D

"""
Base enemy class.
"""

@export var damage_front: Area2D
@export var damage_back: Area2D

@onready var timer: Timer = $Timer

var direction = Vector2.LEFT  # Initial movement direction

# Let each enemy define its own idle animation/movement pattern
func idle(_body, _direction):
	pass

func _ready():
	damage_front.connect("body_entered", Callable(self, "attack_front"))
	timer.stop()
	if damage_back:
		damage_back.connect("body_entered", Callable(self, "attack_back"))

func _process(_delta):
	pass

func change_direction():
	scale.x *= -1
	direction *= -1
	
func attack_front(body):
	if body.is_in_group("protagonist") and timer.is_stopped() and not body.dying:
		timer.start()
		$hit.play()
		body.throw(direction.x)
		body.take_damage(1)

func attack_back(body):
	if body.is_in_group("protagonist") and timer.is_stopped() and not body.dying:
		timer.start()
		$hit.play()
		body.throw(direction.x * -1)
		body.take_damage(1)
