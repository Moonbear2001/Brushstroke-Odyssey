extends Area2D

"""
'Cloud' (a 2d area) that spawns Dali falling faces at intervals controllable
through export variables.
"""

# Low and high bounds (in seconds) between possible face spawns
@export var interval_low: float = 0.5
@export var interval_high: float = 1.0
@export var audio_dist: float = 700
@export var head_scale: Vector2 = Vector2(0.03, 0.03)

@onready var face: PackedScene = preload("res://objects/enemies/face.tscn")
@onready var timer: Timer = $Timer
@onready var cloud_rect: Rect2 = $CollisionShape2D.get_shape().get_rect()

var rng = RandomNumberGenerator.new()
var left_coord: Vector2 
var right_coord: Vector2 
var head_speed = 150

func _ready():
	timer.set_wait_time(rng.randf_range(interval_low, interval_high))
	timer.start()
	
	left_coord = cloud_rect.position
	right_coord = Vector2(cloud_rect.end.x, left_coord.y)
	
	# TESTING
	#print("Cloud rect: ", cloud_rect)
	#print("Left coord: ", left_coord)
	#print("Right coord: ", right_coord)
	#print("Timer wait time: ", timer.get_wait_time())

# Drop a face, pick a new random interval, restart timer
func _on_timer_timeout():
	drop_face()
	timer.stop()
	timer.set_wait_time(rng.randi_range(interval_low, interval_high))
	timer.start()

# Randomly spawn new face and add to the tree
func drop_face():
	var new_face = face.instantiate()
	new_face.set_global_position(Vector2(rng.randi_range(left_coord.x, right_coord.x), left_coord.y))
	new_face.set_scale(head_scale)
	add_child(new_face)
	new_face.set_speed(head_speed)

func increase_speed():
	head_speed += 50
	
func decrease_speed():
	head_speed -= 50
