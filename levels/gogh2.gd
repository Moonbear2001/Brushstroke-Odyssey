extends Level

@onready var camera_anim = $Camera2D/AnimationPlayer
@export var layers: Array[Node2D]
@onready var protagonist_gogh = preload("res://characters/protagonist_gogh.tscn")
@onready var death_arr = $Deaths

var curr_layer = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	$AnimationPlayer.play("scene_in")
	
	for death in death_arr.get_children():
		death.respawn.connect(Callable(self, "respawn"))
	
	# Disable the hitboxes of layers 2 - n and make invisible
	for layer in range(2, layers.size() + 1):
		set_layer_hitboxes_disabled(layer, true)
		layers[layer - 1].hide()
		
	set_layer_hitboxes_disabled(1, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)


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
	var greatest_y_below_target = -INF
	var checkpoint
	for node in get_tree().get_nodes_in_group("checkpoint"):
		if node.global_position.y < protagonist.global_position.y and node.global_position.y > greatest_y_below_target:
			greatest_y_below_target = node.global_position.y
			checkpoint = node
	for p in get_tree().get_nodes_in_group("protagonist"):
		p.queue_free()
		
	if checkpoint.name == "Checkpoint0":
		get_tree().reload_current_scene()
	# Check if a valid x value was found
	elif greatest_y_below_target != -INF:	
		var duplicatedNode = protagonist_gogh.instantiate()
		duplicatedNode.global_position.x = checkpoint.global_position.x
		duplicatedNode.global_position.y = checkpoint.global_position.y
		duplicatedNode.scale = Vector2(1.4, 1.4)
		get_tree().current_scene.add_child(duplicatedNode)
		protagonist = duplicatedNode
		Global.protagonist = protagonist
	else:
		get_tree().reload_current_scene()

# Custom level end behavior for Van Gogh 2, combine time with best time from 
# Van Gogh 1 and save if better
func level_end(body) -> void:
	if not body.is_in_group("protagonist"):
		return
	
	# Get player's scores for this run
	stopwatch.stop_stopwatch()
	var time: float = stopwatch.get_best_time()
	
	# Get best scores
	var level_high_score: LevelHighScore = Global.high_scores.get_level_high_score(level_name)
	var best_time: float = level_high_score.get_best_time()
	
	# Update saved data 
	Global.high_scores.new_last_time(level_name, best_time + time)
	if best_time + time < best_time:
		Global.high_scores.new_low_time(level_name, best_time + time)
	
	# Go back to the main menu
	SceneManager.load_new_scene(Global.MENU_PATH)


func _on_section_seperator_body_exited(body):
	print("in func")
	if body is Protagonist:
		if body.position.y < $StarSectionEntrance.position.y:
			print("playing music")
			$NighttimeAmbience.stop()
			$SoundAmbience.stop_ambience()
			$StarSectionMusic.play(0)
		else:
			$StarSectionMusic.stop()
			$NighttimeAmbience.play(0)
			$SoundAmbience.start_ambience()
