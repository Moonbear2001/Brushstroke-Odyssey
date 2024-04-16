extends Level

@onready var camera_anim = $Camera2D/AnimationPlayer
@export var layers: Array[Node2D]
@onready var protagonist_gogh = preload("res://characters/protagonist_gogh.tscn")
@onready var death_arr = $Deaths
@onready var level_stars = $Sky/LevelStars
@onready var anim = $AnimationPlayer

var curr_layer = 1
var curr_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	anim.play("scene_in")
	
	for death in death_arr.get_children():
		death.respawn.connect(Callable(self, "respawn"))
		if death.name != "Death0":
			death.get_node("AnimationPlayer").play("RESET")
	
	for star in level_stars.get_children():
		star.get_child(0).started_moving.connect(Callable(self, "move_death"))
		star.get_child(0).level_changed.connect(Callable(self, "change_level"))
	
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

func change_level(level_num):
	curr_level = level_num

func respawn():
	for node in get_tree().get_nodes_in_group("checkpoint"):
		if curr_level == 4: 
			curr_level = 3
		if node.name == "Checkpoint" + str(curr_level):
			protagonist.global_position = node.global_position
	for star in level_stars.get_children():
		var idx = star.get_index() + 1
		if idx > curr_level:
			star.get_child(0).reset()
			death_arr.get_child(idx).get_node("AnimationPlayer").play("RESET")
		

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

func move_death(num):
	death_arr.get_child(num).get_node("AnimationPlayer").play("move")
# Play either the section2 or star section ambience depending on whether the 
# protag is going up or falling down
func _on_section_seperator_body_exited(body):
	if body is Protagonist:
		if body.position.y < $StarSectionEntrance.position.y:
			$NighttimeAmbience.stop()
			$SoundAmbience.stop_ambience()
			$StarSectionMusic.play(0)
		else:
			$StarSectionMusic.stop()
			$NighttimeAmbience.play(0)
			$SoundAmbience.start_ambience()



