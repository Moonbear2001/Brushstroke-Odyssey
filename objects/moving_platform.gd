extends Node2D

@export var id: int
@onready var anim = $AnimatableBody2D/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if anim:
		anim.stop()

func playAnimation():
	anim.play("move_platform")
