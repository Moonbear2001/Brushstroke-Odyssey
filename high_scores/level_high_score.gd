class_name LevelHighScore
extends Resource

@export var time: float = INF
@export var collected_stars: int = 0

func get_stars() -> int:
	return collected_stars
	
func get_time() -> float:
	return time
	
func set_stars(stars: int) -> void:
	collected_stars = stars
	
func set_time(new_best_time: float) -> void:
	time = new_best_time
