class_name SoundAmbience
extends Node2D

"""
Kind of like a sound pool, it holds multiple Audio Stream Players and then plays 
sounds at random intervals to give an ambience.
"""

# Seconds between an ambience sound (owl screech, wolf howl, etc.)
@export var interval: int = 10

var sounds: Array[AudioStreamPlayer]
var rng = RandomNumberGenerator.new()
var last_index = -1

func _ready() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			sounds.append(child)
			
# Gets a random item from the pool
func get_random() -> int:
	var index = rng.randi_range(0, len(sounds) - 1)
	while index == last_index:
		index = rng.randi_range(0, len(sounds) - 1)
	last_index = index
	return index

# Play a random sound that is different from the previous sound
func play_random_sound() -> void:
	sounds[get_random()].play()
