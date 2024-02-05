extends Node2D

@export var id: int
@onready var anim = $AnimatableBody2D/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if anim:
		anim.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func playAnimation():
	anim.play("move_platform")
