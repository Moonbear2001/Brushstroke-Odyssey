extends Node2D

@onready var enemy = $Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.attack = Callable(self, "attack")
	
func attack(protagonist, direction):
	protagonist.throw(direction.x)
	protagonist.take_damage()
