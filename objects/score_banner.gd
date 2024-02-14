extends AnimatedSprite2D

"""
Banner that drops down displaying player's score for a level (stars and time).
"""

@export var level_name: String

@onready var animation_player = $AnimationPlayer
@onready var stars = $Stars

const time_label_format = "{time} s"

var num_stars: int
var time: float

func _ready():
	# TODO: use level name to call appropriate animation
	
	# Load saved score data
	var level_hs: LevelHighScore = Global.high_scores.get_level_high_score(level_name)
	num_stars = level_hs.get_stars()
	time = level_hs.get_time()
	
	# Display correct number of stars
	var level_stars = stars.get_children()
	for i in range(num_stars):
		level_stars[i].show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Drop the banner when a the player enters an area
func _on_area_2d_body_entered(body):
	# play drop anim
	pass # Replace with function body.

# Pull the banner back up when a player leaves an area
func _on_area_2d_body_exited(body):
	# play return anim
	pass # Replace with function body.
