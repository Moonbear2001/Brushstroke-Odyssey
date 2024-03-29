class_name Elephant
extends Enemy

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	attack = Callable(self, "attack_protag")
	if weak_area:
		weak_area.connect("body_entered", Callable(self, "death"))

func _process(delta):
	super._process(delta)
	
func attack_protag(protagonist, direction):
	protagonist.throw(direction.x)
	protagonist.take_damage()

func death(body):
	if body.is_in_group("protagonist"):
		timer.start()
		body.throw(0)
		add_gravity()

func _on_timer_timeout():
	queue_free()
