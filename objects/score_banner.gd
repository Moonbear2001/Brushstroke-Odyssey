extends Node2D

"""
Banner that drops down displaying player's score for a level (stars and time).
"""

@export var level_name: String

@onready var animation_player = $AnimationPlayer
@onready var stars = $AnimatedSprite2D/Stars
@onready var sprite = $AnimatedSprite2D
@onready var high_score_label = $AnimatedSprite2D/HighScoreLabel
@onready var last_run_label = $AnimatedSprite2D/LastRunLabel

var num_stars: int
var time: float
var last_time: float

var moving: bool = false
var inside: bool = false

func _ready():
	
	# Reset position
	sprite.position = Vector2.ZERO
	
	# Load saved score data
	var level_hs: LevelHighScore = Global.high_scores.get_level_high_score(level_name)
	num_stars = level_hs.get_best_stars()
	time = level_hs.get_best_time()
	last_time = level_hs.get_last_time()
	
	# Display number of stars
	var level_stars = stars.get_children()
	for i in range(num_stars):
		level_stars[i].show()
		
	# Display times
	if time != INF:
		high_score_label.text = str(time).pad_decimals(2) + " s"
	if last_time != INF:
		last_run_label.text = str(last_time).pad_decimals(2) + " s"
	

# Drop the banner when the player enters the area
func _on_area_2d_body_entered(body):
	if body is Protagonist:
		inside = true
		if !moving:
			animation_player.play("drop_down")
			moving = true
	
# Pull the banner back up when a player leaves the area
func _on_area_2d_body_exited(body):
	if body is Protagonist:
		inside = false
		if !moving:
			animation_player.play("go_up")
			moving = true

# Insures that if the player enters/exits the area during an animation, the 
# banner plays its up/down animation anyway
func _on_animation_player_animation_finished(anim_name):
	moving = false
	if inside and anim_name == "go_up":
		moving = true
		animation_player.play("drop_down")
	elif !inside and anim_name == "drop_down":
		moving = true		
		animation_player.play("go_up")
	
