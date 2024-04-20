extends Enemy

"""
Elephant enemy.
"""

@onready var move_sound = $walk
@onready var walk_timer = $WalkTimer
@onready var animation = $AnimationPlayer
@onready var attack_radius = $AttackRadius

var audio_dist = 1000
var volume = -5
var fade = 100
var attacking = false
var animation_finished = true

var move_speed = 100

func _ready():
	super._ready()
	
func _process(delta):
	super._process(delta)
	if attacking and animation_finished:
		animation.play("attack")
		

func _on_walk_timer_timeout():
	if not Global.protagonist:
		return
	var protag_dist = abs(Global.protagonist.global_position.x - global_position.x)
	if protag_dist < audio_dist:
		move_sound.volume_db = volume - (protag_dist / fade)
		move_sound.play()

func _on_attack_radius_body_entered(body):
	if body.is_in_group("protagonist"):
		attack()

func attack():
	$"pre-attack".play()
	animation.play("attack")
	attacking = true
	animation_finished = false

func _on_attack_radius_body_exited(body):
	attacking = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		animation_finished = true
