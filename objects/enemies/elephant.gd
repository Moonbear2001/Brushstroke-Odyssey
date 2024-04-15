extends Enemy

@export var audio_dist = 700

@onready var move_sound = $walk
@onready var walk_timer = $WalkTimer

var move_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
func _process(_delta):
	pass

func _on_walk_timer_timeout():
	if abs(Global.protagonist.global_position.x - global_position.x) < audio_dist:
		move_sound.play()
