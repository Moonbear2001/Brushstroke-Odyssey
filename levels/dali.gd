extends Level

var enemy_speed = {"skin_blob": 100, "elephant": 100}
@onready var enemies = $Enemies
@onready var clock = $Clock

func _ready():
	for node in enemies.get_children():
		clock.speed_up.connect(speed_up)
		clock.slow_down.connect(slow_down)

func speed_up():
	var valid = protagonist.take_damage(-1, true)
	if valid:
		for node in enemies.get_children():
			node.increase_speed()
		clock.anim.play(str(protagonist.health))

func slow_down():
	var valid = protagonist.take_damage(1, true)
	if valid:
		for node in enemies.get_children():
			node.decrease_speed()
		clock.anim.play(str(protagonist.health))
