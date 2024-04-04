extends Node2D

signal level_move(name)

@export var anim_name = "default"

@onready var timer = $Timer
@onready var anim = $AnimationPlayer

var complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if anim_name == "default":
		anim.play(anim_name)

func _on_area_2d_body_entered(body):
	if body.is_in_group("protagonist") and anim_name != "default" and !complete:
		timer.start()

func _on_timer_timeout():
	timer.stop()
	anim.play(anim_name)
	complete = true
	if anim_name != "default":
		level_move.emit(anim_name)
