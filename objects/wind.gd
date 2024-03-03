extends Node2D

"""
wind
"""
@onready var animation = $AnimationPlayer

# Set to neutral and enabled by default
func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("protagonist"):
		body.inWind = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("protagonist"):
		body.inWind = false

func _on_animation_player_animation_finished(anim_name):
	queue_free()
