extends Enemy

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

func death(body):
	if body.is_in_group("protagonist"):
		$die.play()
		body.throw(0)
		anim.play("death")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
	
