extends Level

var enemy_speed = {"skin_blob": 100, "elephant": 100}

@onready var enemies = $Enemies
@onready var clocks = $Clocks
@onready var head_clouds = $HeadClouds
@onready var timer = $Timer
@onready var tick_sound = $Tick
@onready var anim = $AnimationPlayer

func _ready():
	super._ready()
	protagonist.fade_to_black.connect(Callable(self, "fade_to_black"))
	protagonist.took_damage.connect(Callable(self, "protag_took_damage"))
	
	for clock in clocks.get_children():
		clock.speed_up.connect(speed_up)
		clock.slow_down.connect(slow_down)
	
	
func speed_up():
	var valid = protagonist.take_damage(-1, true)
	if valid:
		if timer.wait_time > 0.125:
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

func protag_took_damage():
	for clock in clocks.get_children():
		clock.anim.play(str(protagonist.health))

func fade_to_black():
	anim.play("scene_out")

func _on_timer_timeout():
	tick_sound.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "scene_out":
		get_tree().reload_current_scene()
