extends Level

var enemy_speed = {"skin_blob": 100, "elephant": 100}

@onready var enemies = $Enemies
@onready var clocks = $Clocks
@onready var head_clouds = $HeadClouds
@onready var timer = $Timer
@onready var tick_sound = $Tick
@onready var anim = $AnimationPlayer
@onready var protagonist_dali = preload("res://characters/protagonist_dali.tscn")

var duplicatedNode
var throw_velocity = 250

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
		throw_velocity += 25
		protagonist.set_throw_velocity(throw_velocity)
		if timer.wait_time > 0.125:
			timer.wait_time /= 2
		for node in get_tree().get_nodes_in_group("enemy"):
			node.increase_speed()
		for clock in clocks.get_children():
			clock.anim.play(str(protagonist.health))
		

func slow_down():
	var valid = protagonist.take_damage(1, true)
	if valid:
		throw_velocity -= 25
		protagonist.set_throw_velocity(throw_velocity)
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
		respawn()

func respawn():
	var greatest_x_below_target = -INF
	var checkpoint
	var old_protagonist = get_tree().get_nodes_in_group("protagonist")[0]
	
	for node in get_tree().get_nodes_in_group("checkpoint"):
		if node.global_position.x < old_protagonist.global_position.x and node.global_position.x > greatest_x_below_target:
			greatest_x_below_target = node.global_position.x
			checkpoint = node
	for p in get_tree().get_nodes_in_group("protagonist"):
		p.queue_free()
		
	# Check if a valid x value was found
	if greatest_x_below_target != -INF:
		duplicatedNode = protagonist_dali.instantiate()
		#duplicatedNode.global_position.x = checkpoint.global_position.x
		#duplicatedNode.global_position.y = checkpoint.global_position.y
		duplicatedNode.position.x = checkpoint.position.x
		duplicatedNode.position.y = checkpoint.position.y
		get_tree().current_scene.add_child(duplicatedNode)
		duplicatedNode.fade_to_black.connect(Callable(self, "fade_to_black"))
		duplicatedNode.set_throw_velocity(throw_velocity)
		Global.protagonist = duplicatedNode
		protagonist = duplicatedNode
		anim.play("scene_in")
		protag_took_damage()
	else:
		get_tree().reload_current_scene()
