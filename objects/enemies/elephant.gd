extends Node2D

@export var protagonist: Protagonist
@export var audio_dist: float

@onready var timer = $Timer
@onready var enemy = $Enemy
@onready var move_sound = $walk
@onready var walk_timer = $WalkTimer

var move_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.attack = Callable(self, "attack")
	enemy.move = Callable(self, "move")
	
func attack(protagonist, direction):
	$hit.play()
	protagonist.throw(direction.x)
	protagonist.take_damage(1)

func move(delta):
	enemy.velocity.x = enemy.direction.x * move_speed
	if enemy.use_gravity:
		enemy.velocity.y += enemy.gravity * delta

func increase_speed():
	move_speed += 50
	walk_timer.wait_time /= 2

func decrease_speed():
	move_speed -= 50
	walk_timer.wait_time *= 2

func _on_timer_timeout():
	queue_free()

func _on_walk_timer_timeout():
	if abs(protagonist.global_position.x - enemy.global_position.x) < audio_dist:
		move_sound.play()
