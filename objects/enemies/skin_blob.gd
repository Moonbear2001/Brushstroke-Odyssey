extends Enemy

@export var audio_dist = 700

# The main playable character
@onready var move_sound = $move
@onready var anim = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
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
		body.throw(0)
		anim.play("death")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
	
