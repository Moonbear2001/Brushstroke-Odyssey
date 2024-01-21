class_name HighScores
extends Resource

"""
A resource holding high scores that is saved and loaded in the users's 
directory. Each function that chances the high scores should be ended with a 
save operation so that those functions can be safely called from outside this 
script.
"""

const HIGH_SCORES_PATH = Global.SAVE_DATA_PATH + "high_scores.tres"

@export var high_scores : Dictionary

# Initialize the high scores dictionary and each level's high scores to 0 and 
# save the data
func reset_scores() -> void:
	high_scores = {}
	for level in Global.LEVELS:
		high_scores[level] = 0.0
	save_high_scores()

# Check if high scores exist
static func high_scores_exist() -> bool:
	return ResourceLoader.exists(HIGH_SCORES_PATH)

# Load in the save game data
static func load_high_scores() -> Resource:
	return ResourceLoader.load(HIGH_SCORES_PATH)

# Saves high scores to the user directory
func save_high_scores() -> void:
	ResourceSaver.save(self, HIGH_SCORES_PATH)

# Write a new high score
func new_high_score(level: String, score: float):
	high_scores[level] = score
	save_high_scores()
	
# Get a level's high score
func get_level_high_score(level: String) -> float:
	return high_scores[level]
