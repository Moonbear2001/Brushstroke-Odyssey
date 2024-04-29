extends Level

var enemy_speed = {"skin_blob": 100, "elephant": 100}

@onready var enemies = $Enemies
@onready var clocks = $Clocks
@onready var head_clouds = $HeadClouds
@onready var timer = $Timer
@onready var tick_sound = $Tick
@onready var anim = $AnimationPlayer
@onready var protagonist_dali = preload("res://characters/protagonist_dali.tscn")

var skin_blob = preload("res://objects/enemies/skin_blob.tscn")

var duplicatedNode
var throw_velocity = 350
var speed_change = 0

func _ready():
	super._ready()
	protagonist.fade_to_black.connect(Callable(self, "fade_to_black"))
	protagonist.took_damage.connect(Callable(self, "protag_took_damage"))
	protagonist.set_throw_velocity(throw_velocity)
	
	for clock in clocks.get_children():
		clock.speed_up.connect(speed_up)
		clock.slow_down.connect(slow_down)
	
	
func speed_up():
	var valid = protagonist.take_damage(-1, true)
	if valid:
		speed_change += 20
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
		speed_change -= 20
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
		duplicatedNode.took_damage.connect(Callable(self, "protag_took_damage"))
		duplicatedNode.set_throw_velocity(throw_velocity)
		Global.protagonist = duplicatedNode
		protagonist = duplicatedNode
		
		## RESPAWN SKIN BLOBS 
		var new_skin_blob
		if $Enemies/Path2D21.get_child_count() == 0:
			new_skin_blob = skin_blob.instantiate()
			new_skin_blob.move_speed = 120 + speed_change
			new_skin_blob.scale.x = 0.2
			new_skin_blob.scale.y = 0.2
			$Enemies/Path2D21.add_child(new_skin_blob)
		if $Enemies/Path2D20.get_child_count() == 0:
			new_skin_blob = skin_blob.instantiate()
			new_skin_blob.move_speed = 140 + speed_change
			new_skin_blob.scale.x = 0.15
			new_skin_blob.scale.y = 0.15
			$Enemies/Path2D20.add_child(new_skin_blob)
		if $Enemies/Path2D15.get_child_count() == 0:
			new_skin_blob = skin_blob.instantiate()
			new_skin_blob.move_speed = 110 + speed_change
			new_skin_blob.scale.x = 0.25
			new_skin_blob.scale.y = 0.25
			$Enemies/Path2D15.add_child(new_skin_blob)
		if $Enemies/Path2D16.get_child_count() == 0:
			new_skin_blob = skin_blob.instantiate()
			new_skin_blob.move_speed = 140 + speed_change
			new_skin_blob.scale.x = 0.15
			new_skin_blob.scale.y = 0.15
			$Enemies/Path2D16.add_child(new_skin_blob)
		if $Enemies/Path2D17.get_child_count() == 0:
			new_skin_blob = skin_blob.instantiate()
			new_skin_blob.move_speed = 70 + speed_change
			new_skin_blob.scale.x = 0.3
			new_skin_blob.scale.y = 0.3
			$Enemies/Path2D17.add_child(new_skin_blob)
		
		anim.play("scene_in")
		print("protagonist health: ", protagonist.health)
		protag_took_damage()
	else:
		get_tree().reload_current_scene()
