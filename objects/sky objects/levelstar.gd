extends Node2D

signal level_changed(level_num)
signal started_moving(level_num)

@export_enum ("move_5", "move_10") var anim_name = "move_5"
@export var level: int

@onready var anim = $AnimationPlayer

var triggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
func reset():
	anim.play("RESET")
	triggered = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("protagonist") and !triggered:
		anim.play(anim_name)
		triggered = true
		started_moving.emit(level)

func _on_animation_player_animation_finished(anim_name):
	if anim_name != "RESET":
		level_changed.emit(level)
