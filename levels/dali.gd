extends Level

var enemy_speed = {"skin_blob": 100, "elephant": 100}
@onready var enemies = $Enemies
@onready var clocks = $Clocks
@onready var timer = $Timer
@onready var tick_sound = $Tick

func _ready():
	super._ready()
	for node in enemies.get_children():
		for clock in clocks.get_children():
			clock.speed_up.connect(speed_up)
			clock.slow_down.connect(slow_down)

func speed_up():
	var valid = protagonist.take_damage(-1, true)
	if valid:
		timer.wait_time /= 2
		for node in get_tree().get_nodes_in_group("enemy"):
			node.increase_speed()
		for clock in clocks.get_children():
			clock.anim.play(str(protagonist.health))

func slow_down():
	var valid = protagonist.take_damage(1, true)
	if valid:
		timer.wait_time *= 2
		for node in get_tree().get_nodes_in_group("enemy"):
			node.decrease_speed()
		for clock in clocks.get_children():
			clock.anim.play(str(protagonist.health))


func _on_timer_timeout():
	tick_sound.play()
