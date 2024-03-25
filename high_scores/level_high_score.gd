class_name LevelHighScore
extends Resource

"""
Resource that can be saved and loaded that contains all the high score info
about a level.
This Resource is wrapped by the HighScores resources when actually saved.
"""

@export var last_time: float = INF
@export var best_time: float = INF
@export var collected_stars: int = 0

### Getters ###

func get_last_time() -> float:
	return last_time

func get_best_time() -> float:
	return best_time

func get_best_stars() -> int:
	return collected_stars

### Setters ###

func set_last_time(new_last_time: float) -> void:
	last_time = new_last_time
	
func set_best_time(new_best_time: float) -> void:
	best_time = new_best_time
	
func set_best_stars(stars: int) -> void:
	collected_stars = stars
	


