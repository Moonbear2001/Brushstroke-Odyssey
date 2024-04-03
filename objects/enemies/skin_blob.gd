extends Node2D

@export var protagonist: Protagonist
@export var audio_dist: float

# The main playable character
@onready var enemy = $Enemy
@onready var timer = $Timer
@onready var move = $move

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.stop()
	enemy.attack = Callable(self, "attack")
	if enemy.weak_area:
		enemy.weak_area.connect("body_entered", Callable(self, "death"))

func _process(delta):
	if move.playing == false and abs(protagonist.global_position.x - enemy.global_position.x) < audio_dist:
		move.play()
	elif move.playing == true and abs(protagonist.global_position.x - enemy.global_position.x) > audio_dist:
		move.stop()
	
func attack(protagonist, direction):
	$hit.play()
	protagonist.throw(direction.x)
	protagonist.take_damage()

func death(body):
	if body.is_in_group("protagonist"):
		$die.play()
		timer.start()
		body.throw(0)
		enemy.add_gravity()

func _on_timer_timeout():
	queue_free()
