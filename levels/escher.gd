extends Level

@onready var protagonist_escher = preload("res://characters/protagonist_escher.tscn")
@onready var deaths = $Deaths

var duplicatedNode

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	for death in deaths.get_children():
		death.respawn.connect(Callable(self, "respawn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func respawn():
	var greatest_x_below_target = -INF
	var checkpoint
	
	for node in get_tree().get_nodes_in_group("checkpoint"):
		if node.global_position.x < protagonist.global_position.x and node.global_position.x > greatest_x_below_target:
			greatest_x_below_target = node.global_position.x
			checkpoint = node
	for p in get_tree().get_nodes_in_group("protagonist"):
		p.queue_free()
		
	# Check if a valid x value was found
	if greatest_x_below_target != -INF:
		duplicatedNode = protagonist_escher.instantiate()
		duplicatedNode.global_position.x = checkpoint.global_position.x
		if "x_offset" in checkpoint:
			duplicatedNode.global_position.x += checkpoint.x_offset
		duplicatedNode.global_position.y = checkpoint.global_position.y
		if "y_offset" in checkpoint:
			duplicatedNode.global_position.y += checkpoint.y_offset
		get_tree().current_scene.add_child(duplicatedNode)
		duplicatedNode.set_gravity("down")
	else:
		get_tree().reload_current_scene()
