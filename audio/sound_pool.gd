class_name SoundPool
extends Node2D

"""
A pool of sounds that are chosen at random and then played. Useful for when you 
have a variety of sounds that should be chosen from (footsteps, bullets, etc.) 
and not sound repetitive.
"""

var sounds: Array[AudioStreamPlayer]
var rng = RandomNumberGenerator.new()
var last_index = -1

func _ready() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			sounds.append(child)

# Play a random sound that is different from the previous sound
func play_random_sound() -> void:
	var index = rng.randi_range(0, len(sounds) - 1)
	while index == last_index:
		index = rng.randi_range(0, len(sounds) - 1)
	last_index = index
	sounds[index].play()
