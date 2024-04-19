extends Node2D

"""
Pool with shader ripple effect that reflects the protagonist.
"""

@onready var protag_reflection = $Reflections/ProtagReflection
@onready var reflections = $Reflections
@onready var face: PackedScene = preload("res://objects/head_reflection.tscn")
@onready var surface_y = $Surface.position.y
@onready var reflection_threshold_y = $ReflectionThreshold.position.y

var protagonist
const height = 70
@onready var reflection_start = surface_y + (surface_y - reflection_threshold_y)

var head_reflections = []

func _ready():
	set_physics_process(false)
	
func _input(_event):
	if Input.is_action_just_pressed("jump"):
		$AnimationPlayer.play("protag_reflec_invis")

func _physics_process(delta):
	protag_reflection.set_global_position(Vector2(protagonist.get_global_position().x, protagonist.get_global_position().y + height))
	for head_reflection in head_reflections:
		head_reflection.position.y -= 50 * delta
		if head_reflection.position.y <= surface_y:
			head_reflection.play("splat")

func _on_area_2d_body_entered(body):
	if body is Protagonist:
		set_physics_process(true)
		protagonist = body
		
	# Make a new face reflection
	elif body.is_in_group("faces"):
		var face_reflection = face.instantiate()
		face_reflection.set_global_position(Vector2(body.global_position.x, global_position.y + height))
		reflections.add_child(face_reflection)
		head_reflections.append(face_reflection)
		body.tree_exiting.connect(destroy_reflection)

func _on_area_2d_body_exited(body):
	if body is Protagonist:
		set_physics_process(false)
		protagonist = null
		
func destroy_reflection():
	var last = head_reflections.pop_front()
	last.queue_free()
