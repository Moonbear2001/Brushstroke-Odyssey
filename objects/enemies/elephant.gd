extends Enemy

"""
Elephant enemy.
"""

@onready var move_sound = $walk
@onready var walk_timer = $WalkTimer
@onready var animation = $AnimationPlayer

var audio_dist = 1000
var volume = -20
var fade = 100

var move_speed = 100

func _ready():
	super._ready()

func _on_walk_timer_timeout():
	if not Global.protagonist:
		return
	var protag_dist = abs(Global.protagonist.global_position.x - global_position.x)
	if protag_dist < audio_dist:
		move_sound.volume_db = volume - (protag_dist / fade)
		move_sound.play()
