extends Node2D

@export var protagonist: Protagonist
@export var audio_dist: float

# The main playable character
@onready var enemy = $Enemy
@onready var timer = $Timer
@onready var move_sound = $move

var move_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.stop()
	enemy.attack = Callable(self, "attack")
	enemy.move = Callable(self, "move")
	if enemy.weak_area:
		enemy.weak_area.connect("body_entered", Callable(self, "death"))

func _process(delta):
	if move_sound.playing == false and abs(protagonist.global_position.x - enemy.global_position.x) < audio_dist:
		move_sound.play()
	elif move_sound.playing == true and abs(protagonist.global_position.x - enemy.global_position.x) > audio_dist:
		move_sound.stop()
	
func attack(protagonist, direction):
	$hit.play()
	protagonist.throw(direction.x)
	protagonist.take_damage(1)

func death(body):
	if body.is_in_group("protagonist"):
		$die.play()
		timer.start()
		body.throw(0)
		enemy.add_gravity()

func move(delta):
	enemy.velocity.x = enemy.direction.x * move_speed
	if enemy.use_gravity:
		enemy.velocity.y += enemy.gravity * delta

func increase_speed():
	move_speed += 50

func decrease_speed():
	move_speed -= 50
	
func _on_timer_timeout():
	queue_free()
