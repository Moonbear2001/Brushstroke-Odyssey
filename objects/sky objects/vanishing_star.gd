extends Node2D

@export_enum("star", "star2") var chosen_animation: String = "star"
@onready var animation = $StaticBody2D/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play(chosen_animation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
