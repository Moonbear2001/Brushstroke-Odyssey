extends Area2D

"""
Door that teleports the player to another door.
"""

@export_enum("down", "up", "left", "right") var gravity_dir:String = "down"
@export var id:int = -1
@export var enter: bool = true
@export var exit_id:int = -1
@export var x_offset = 0
@export var y_offset = 0

# Enums that describe direction, color, and state
# These help with choosing which animation to play
@export_enum("black", "yellow", "red", "blue", "gold", "white") var color: String
@export_enum("open", "closed") var state: String

@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea
@onready var anim_player = $AnimationPlayer

var lock_door = false

# Play the closed door animation on scene startup
func _ready() -> void:
	var start_anim = build_anim_name(color, state)
	animated_sprite.play(start_anim)

# When the door is entered
func _on_body_entered(body):
	if body.is_in_group("protagonist") and enter:
		teleport(body) 

# When the body is exited
func _on_body_exited(body):
	if body.is_in_group("protagonist") and !lock_door:
		state = "closed"
		var close_anim = build_anim_name(color, state)
		animated_sprite.play(close_anim)

# Teleports the player to the new location
func teleport(body):
	for door in get_tree().get_nodes_in_group("door"):
		if door != self && door.id == exit_id: 
			if !door.lock_door:
				lock()
				body.global_position.x = door.global_position.x + door.x_offset
				body.global_position.y = door.global_position.y + door.y_offset
				
				body.set_gravity(door.gravity_dir)
				
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
	

func _on_interaction_area_area_entered(area):
	if enter:
		# Play door opening animation
		state = "open"
		var open_anim = build_anim_name(color, state)
		animated_sprite.play(open_anim)


func _on_interaction_area_area_exited(area):
	if state == "open":
		# Play door closing animation
		state = "closed"
		var close_anim = build_anim_name(color, state)
		animated_sprite.play(close_anim)
