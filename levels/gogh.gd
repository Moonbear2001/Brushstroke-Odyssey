extends Level

"""
Custom level script for the Van Gogh level.
"""

@export var lantern: PointLight2D
@export var fuel_bar: Control
@export var refill_stations: Node2D

@export var layers: Array[Node2D]

@onready var wind_timer = $WindTimer
@onready var camera_anim = $Camera2D/AnimationPlayer
@onready var death = $Death
@onready var protagonist_gogh = preload("res://characters/protagonist_gogh.tscn")
@onready var new_lantern = preload("res://objects/lantern.tscn")
@onready var trees = $"Layers/1/Trees"
@onready var parallax_foreground = $ParallaxBackground2

var windArr: Array[Node2D]
var wind = preload("res://objects/wind.tscn")
var smallwind = preload("res://objects/small_wind/breeze.tscn")

var curr_layer = 1

func _ready():
	# Call the base level script's _ready()
	super._ready()
	protagonist.glow = true
	death.respawn.connect(Callable(self, "respawn"))
	
	# Hook up the refill station's signals here because its a pain to do it
	# one by one in the Godot editor (also not good design)
	for refill_station in refill_stations.get_children():
		refill_station.refuel_light.increment_fuel_level.connect(lantern.increment_fuel)
		refill_station.refuel_light.refuel_area_entered.connect(lantern.refueling_started)
		refill_station.refuel_light.refuel_area_exited.connect(lantern.refueling_stopped)
		refill_station.exit_station.connect(on_refill_station_exited)
		
	# Disable the hitboxes of layers 2 - n and make invisible

	for layer in range(2, layers.size() + 1):
		set_layer_hitboxes_disabled(layer, true)
		layers[layer - 1].hide()
		
	set_layer_hitboxes_disabled(1, false)
	

# Call the base level script's _process()
func _process(delta):
	super._process(delta)
	
	change_glow()
	
	if protagonist.global_position.x > 500 and wind_timer.is_stopped():
		wind_timer.start()
	elif protagonist.global_position.x <= 500:
		wind_timer.stop()

# When exiting refill station, put protag back on top of station
func on_refill_station_exited(exit_pos):
	protagonist.global_position = exit_pos.get_global_position()
	protagonist.glow = true

# Reload the level when fuel is exhausted
func _on_lantern_fuel_exhausted():
	respawn()

func change_glow():
	var glow_num = floori(lantern.fuel_level / 30 * 10)
	protagonist.glow_level = str(glow_num)
	
# Change to the next layer
func _on_layer_change_area_body_entered(body):
	if body is Protagonist:
		# Disable the previous layer's hitboxes
		set_layer_hitboxes_disabled(curr_layer, true)
		
		# Enable the next layer's hitboxes
		set_layer_hitboxes_disabled(curr_layer + 1, false)
				
		# Change camera zoom and protag scale
		camera_anim.play("zoom_out_" + str(curr_layer))
		
		# Show the new layer
		layers[curr_layer].show()
		
		curr_layer += 1

# Enable or disable all of the hitboxes in a layer
# disabled = true disables the hitbox
# disabled = false enables the hitbox
func set_layer_hitboxes_disabled(layer_num: int, disabled: bool):
	for child in get_all_children(layers[layer_num - 1]):
		if child is CollisionPolygon2D or child is CollisionShape2D:
			child.set_deferred("disabled", disabled)

# Recursively get all children of a node
func get_all_children(node) -> Array:
	var nodes : Array = []
	for child in node.get_children():
		if child.get_child_count() > 0:
			nodes.append(child)
			nodes.append_array(get_all_children(child))
		else:
			nodes.append(child)
	return nodes
	
func respawn():
	var greatest_x_below_target = -INF
	var checkpoint
	for node in get_tree().get_nodes_in_group("checkpoint"):
		if node is RefuelStation and node.visited and node.global_position.x < protagonist.global_position.x and node.global_position.x > greatest_x_below_target:
			greatest_x_below_target = node.global_position.x
			checkpoint = node
	for p in get_tree().get_nodes_in_group("protagonist"):
		p.queue_free()
		
	# Check if a valid x value was found
	if greatest_x_below_target != -INF:	
		var duplicatedNode = protagonist_gogh.instantiate()
		var duplicateLantern = new_lantern.instantiate()
		duplicatedNode.add_child(duplicateLantern)
		duplicatedNode.glow = true
		duplicatedNode.global_position.x = checkpoint.checkpoint_pos.global_position.x
		duplicatedNode.global_position.y = checkpoint.checkpoint_pos.global_position.y
		get_tree().current_scene.add_child(duplicatedNode)
		protagonist = duplicatedNode
		lantern = duplicateLantern
		lantern.fuel_exhausted.connect(Callable(self, "respawn"))
		for refill_station in refill_stations.get_children():
			refill_station.refuel_light.increment_fuel_level.connect(lantern.increment_fuel)
			refill_station.refuel_light.refuel_area_entered.connect(lantern.refueling_started)
			refill_station.refuel_light.refuel_area_exited.connect(lantern.refueling_stopped)
		Global.protagonist = protagonist
		duplicatedNode.set_gravity("down")
	else:
		get_tree().reload_current_scene()

#func cont() -> void:
	#$AnimationPlayer.play("scene_out")
	#await $AnimationPlayer.animation_finished
	#get_tree().change_scene_to_file("res://levels/gogh2.tscn")
	#$AnimationPlayer.play("scene_in")


func _on_wind_timer_timeout():
	spawn_smallwind()

func spawn_wind():
	var screen_size = get_viewport_rect().size
	var x_pos = camera.global_position.x + floori(screen_size.x / 2)

	var newWind = wind.instantiate()
	newWind.global_position = Vector2(x_pos, 260)
	add_child(newWind)
	sway_trees()
	
	
func spawn_smallwind():
	$Gust.play(2)
	var screen_size = get_viewport_rect().size
	var x_pos = camera.global_position.x + floori(screen_size.x / 2)

	var newWind = smallwind.instantiate()
	newWind.breeze_finished.connect(Callable(self, "spawn_wind"))
	newWind.global_position = Vector2(x_pos, 260)
	add_child(newWind)
	sway_trees()

func sway_trees():
	var tree_arr = trees.get_children()
	for tree in tree_arr:
		tree.sway()


func _on_area_2d_body_entered(body):
	if body.is_in_group("protagonist"):
		SceneManager.load_new_scene("res://levels/gogh2.tscn")

# When character gets close to bell tower, ring the bell
func _on_bell_sound_area_body_entered(body):
	$Bells.play()
