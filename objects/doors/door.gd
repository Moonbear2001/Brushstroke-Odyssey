extends Area2D

"""
Door that teleports the player to another door.
"""

@export_enum("down", "up", "left", "right") var gravity_dir:String = "down"
@export var id: int = -1
@export var enter: bool = true
@export var exit_id: int = -1
@export var x_offset = 0
@export var y_offset = 0
@export_enum("black", "yellow", "red", "blue", "green", "purple") var color: String
@export_enum("open", "closed") var state: String = "closed"
@export var duplicate: bool = false
@export var duplicate_id: int = -1
# Enums that describe direction, color, and state
# These help with choosing which animation to play

@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea
@onready var anim_player = $AnimationPlayer
@onready var protagonist = preload("res://characters/protagonist_escher.tscn")

const CLOSE_SOUND_PATH: String = "res://audio/sfx/shutting-the-door-119118.mp3"
const OPEN_SOUND_PATH: String = "res://audio/sfx/open-doors-114615.mp3"

var close_sound_stream: AudioStream
var open_sound_stream: AudioStream

var close_sound = AudioStreamPlayer.new()
var open_sound = AudioStreamPlayer.new()

var lock_door = false

func _ready() -> void:
	
	# Set up opening and closing sounds
	close_sound_stream = load(CLOSE_SOUND_PATH)
	open_sound_stream = load(OPEN_SOUND_PATH)
	close_sound.set_stream(close_sound_stream)
	open_sound.set_stream(open_sound_stream)
	close_sound.set_bus("SFX")
	open_sound.set_bus("SFX")
	close_sound.volume_db = -5
	open_sound.volume_db = -5
	add_child(close_sound)
	add_child(open_sound)
	
	# Play correct starting animation
	var start_anim = build_anim_name(color, state)
	animated_sprite.play(start_anim)

# When the door is entered
func _on_body_entered(body):
	if body.is_in_group("protagonist") and enter:
		if duplicate:
			body.queue_free()
			if Global.waiting_for_duplicate:
				var newNode: Protagonist = protagonist.instantiate()
				teleport(newNode)
		else:
			teleport(body)
			if duplicate_id > 0:
				duplicate_node(body)

# When the body is exited
func _on_body_exited(body):
	if body.is_in_group("protagonist") and !lock_door:
		state = "closed"
		var close_anim = build_anim_name(color, state)
		animated_sprite.play(close_anim)
		#close_sound.play()

# Teleports the player to the new location
func teleport(body):
	for door in get_tree().get_nodes_in_group("door"):
		if door != self and door.id == exit_id and not door.lock_door: 
			#delay if the duplicate protagonist still exists
			if len(get_tree().get_nodes_in_group("protagonist")) > 1:
				Global.waiting_for_duplicate = true
				body.queue_free()
				return
			lock()
			body.global_position.x = door.global_position.x + door.x_offset
			body.global_position.y = door.global_position.y + door.y_offset
			
			if Global.waiting_for_duplicate:
				get_tree().current_scene.add_child(body)	
				Global.waiting_for_duplicate = false
			body.set_gravity(door.gravity_dir)
			
			# Exit animation + sound
			if not door.enter:
				door.anim_player.play(door.color + "_exit")
				
				
			break

# Lock the door for a while after the player enters it
func lock():
	lock_door = true
	$Timer.start()

# Re-enable the door and close it 
func _on_timer_timeout():
	lock_door = false
	#state = "closed"
	#var close_anim = build_anim_name(color, state, direction)
	#animated_sprite.play(close_anim)
	
# Utility function to help build the animation name
func build_anim_name(color: String, state: String) -> String:
	return color + "_" + state 

func _on_animated_sprite_2d_animation_finished():
	state = "closed"
	var start_anim = build_anim_name(color, state)
	animated_sprite.play(start_anim) 
	

func _on_interaction_area_area_entered(_area):
	if enter:
		# Play door opening animation
		state = "open"
		var open_anim = build_anim_name(color, state)
		animated_sprite.play(open_anim)
		open_sound.play()


func _on_interaction_area_area_exited(_area):
	if state == "open":
		# Play door closing animation
		state = "closed"
		var close_anim = build_anim_name(color, state)
		animated_sprite.play(close_anim)
		close_sound.play()
		
		
func duplicate_node(body):
	var duplicatedNode: Protagonist = body.duplicate()
	for door in get_tree().get_nodes_in_group("door"):
		if door.id == duplicate_id and door != self and not door.lock_door:
			door.lock()
			duplicatedNode.global_position.x = door.global_position.x + door.x_offset
			duplicatedNode.global_position.y = door.global_position.y + door.y_offset
				
			get_tree().current_scene.add_child(duplicatedNode)	
			duplicatedNode.set_gravity(door.gravity_dir)
			break
