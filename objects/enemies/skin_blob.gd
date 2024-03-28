extends Node2D

@onready var enemy = $Enemy
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.stop()
	enemy.attack = Callable(self, "attack")
	if enemy.weak_area:
		enemy.weak_area.connect("body_entered", Callable(self, "death"))
	
func attack(protagonist, direction):
	protagonist.throw(direction.x)
	protagonist.take_damage()

func death(body):
	if body.is_in_group("protagonist"):
		timer.start()
		body.throw(0)
		enemy.add_gravity()

func _on_timer_timeout():
	queue_free()
