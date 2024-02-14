class_name LevelHighScore
extends Resource

var time: float = INF
var collected_stars: int = 0

func get_stars() -> int:
	return collected_stars
	
func get_time() -> float:
	return time
	
func set_stars(stars: int) -> void:
	collected_stars = stars
	
func set_time(time: float) -> void:
	print("set time")
	time = time
