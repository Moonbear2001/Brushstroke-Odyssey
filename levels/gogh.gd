extends Level

"""
Custom level script for the Van Gogh level.
"""

@export var lantern: PointLight2D
@export var fuel_bar: Control
@export var refill_stations: Node2D

@export var layers: Array[Node2D]

@onready var spawnTimer = $Timer
@onready var camera_anim = $Camera2D/AnimationPlayer

var windArr: Array[Node2D]
var wind = preload("res://objects/wind.tscn")

var curr_layer = 1

func _ready():
	# Call the base level script's _ready()
	super._ready()
	protagonist.glow = true
	
	# Hook up the refill station's signals here because its a pain to do it
	# one by one in the Godot editor (also not good design)
	for refill_station in refill_stations.get_children():
		refill_station.increment_fuel_level.connect(lantern.increment_fuel)
		refill_station.refuel_area_entered.connect(lantern.refueling_started)
		refill_station.refuel_area_exited.connect(lantern.refueling_stopped)
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
	
	if protagonist.global_position.x > 500 and spawnTimer.is_stopped():
		spawnTimer.start()
	elif protagonist.global_position.x <= 500:
		spawnTimer.stop()
	
	if spawnTimer.time_left <= 3.6:
		free_wind()

# When exiting refill station, put protag back on top of station
func on_refill_station_exited(exit_pos):
	protagonist.global_position = exit_pos.get_global_position()
	protagonist.glow = true

# Reload the level when fuel is exhausted
func _on_lantern_fuel_exhausted():
	get_tree().reload_current_scene()

func spawn_wind():

	var screen_size = get_viewport_rect().size
	var x_pos = camera.global_position.x + floori(screen_size.x / 2)

	var newWind = wind.instantiate()
	newWind.global_position = Vector2(x_pos, 260)
	add_child(newWind)
	windArr.append(newWind)

func _on_timer_timeout():
	spawn_wind()

func free_wind():
	for wind in windArr:
		wind.queue_free()
	windArr.clear()
	
func change_glow():
	var glow_num = floori(fuel_bar.fuel_lvl / 11)
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

	
	
	
