extends PathFollow2D

"""

"""

@export var move_speed = 100
@export var attack_radius = 136

@onready var enemy = $Enemy

var direction = 1

func _ready():
	if $Enemy/AttackRadius:
		$Enemy/AttackRadius/CollisionShape2D.shape.radius = attack_radius
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_instance_valid(enemy):
		queue_free()
	
	progress += move_speed * delta * direction
	
	if progress_ratio >= 1 or progress_ratio <= 0:
		direction *= -1
		if is_instance_valid(enemy):
			enemy.change_direction()

func increase_speed():
	move_speed += 20
	if $Enemy/AttackRadius:
		$Enemy/AttackRadius/CollisionShape2D.shape.radius += 10

func decrease_speed():
	move_speed -= 20
	if $Enemy/AttackRadius:
		$Enemy/AttackRadius/CollisionShape2D.shape.radius -= 10
