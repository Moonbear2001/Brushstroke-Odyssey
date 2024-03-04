extends Node2D
@onready var tree = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func sway():
	if tree.is_playing():
		tree.stop()
	tree.play("swaying")
