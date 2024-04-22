extends Node2D

"""
Pool with shader ripple effect that reflects the protagonist.
"""

@onready var protag_reflection = $ProtagReflection
@onready var reflections = $Reflections
@onready var face: PackedScene = preload("res://objects/head_reflection.tscn")
@onready var surface_y = $Surface.global_position.y
@onready var reflection_threshold_y = $ReflectionThreshold.global_position.y

var protagonist
const height = 70
@onready var reflection_start = surface_y + (surface_y - reflection_threshold_y)

var free_head_reflections = []
var used_head_reflections = []


func _ready():
	set_physics_process(false)
	free_head_reflections = $Reflections.get_children()
	
func _input(_event):
	if Input.is_action_just_pressed("jump"):
		$AnimationPlayer.play("protag_reflec_invis")

func _physics_process(delta):
	protag_reflection.set_global_position(Vector2(protagonist.get_global_position().x, protagonist.get_global_position().y + 80))
	for head_reflection in used_head_reflections:
		if head_reflection.global_position.y <= surface_y + 100:
			head_reflection.play("splat")
			#head_reflection.animation_finished.connect(stop_spaz)
		else:
			head_reflection.position.y -= 50 * delta
			

#func stop_spaz():
	#head_reflection.play("splat_end")

func _on_area_2d_body_entered(body):
	if body is Protagonist:
		set_physics_process(true)
		protagonist = body
		
	# Make a new face reflection
	elif body.is_in_group("faces"):
		var face_reflection = free_head_reflections.pop_back()
		face_reflection.set_global_position(Vector2(body.global_position.x, global_position.y + height))
		face_reflection.set_visible(true)
		face_reflection.play("default")
		face_reflection.set_scale(body.scale)
		used_head_reflections.append(face_reflection)
		body.tree_exiting.connect(destroy_reflection)

func _on_area_2d_body_exited(body):
	if body is Protagonist:
		set_physics_process(false)
		protagonist = null
		
func destroy_reflection():
	var last = used_head_reflections.pop_front()
	last.set_visible(false)
	free_head_reflections.append(last)
