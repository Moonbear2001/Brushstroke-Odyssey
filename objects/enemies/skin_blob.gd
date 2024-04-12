extends Enemy

@export var audio_dist: float

# The main playable character
@onready var death_timer = $DeathTimer
@onready var move_sound = $move


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	death_timer.stop()
	if weak_area:
		weak_area.connect("body_entered", Callable(self, "death"))

func _process(delta):
	super._process(delta)
	if not Global.protagonist:
		return
	if move_sound.playing == false and abs(Global.protagonist.global_position.x - global_position.x) < audio_dist:
		move_sound.play()
	elif move_sound.playing == true and abs(Global.protagonist.global_position.x - global_position.x) > audio_dist:
		move_sound.stop()

func death(body):
	if body.is_in_group("protagonist"):
		$die.play()
		death_timer.start()
		body.throw(0)
	
func _on_death_timer_timeout():
	queue_free()
