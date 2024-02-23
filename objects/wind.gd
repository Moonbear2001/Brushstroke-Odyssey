extends Node2D

"""
wind
"""
@onready var animation = $AnimationPlayer

# Set to neutral and enabled by default
func _ready():
	animation.play("blowing")

func _on_area_2d_body_entered(body):
	if body.is_in_group("protagonist"):
		body.inWind = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("protagonist"):
		body.inWind = false
