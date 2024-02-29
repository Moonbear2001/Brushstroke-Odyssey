extends Level

@onready var camera_anim = $Camera2D/AnimationPlayer
@export var layers: Array[Node2D]

var curr_layer = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	$AnimationPlayer.play("scene_in")
	
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
