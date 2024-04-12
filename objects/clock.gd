extends Node2D

signal speed_up
signal slow_down

@onready var timer = $Timer
@onready var speed_up_text = $SpeedUp
@onready var slow_down_text = $SlowDown
@onready var anim = $AnimatedSprite2D

var is_slowing_down = false
var is_speeding_up = false
var in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.stop()
	speed_up_text.display_text("[E] to speed up")
	slow_down_text.display_text("[Q] to slow down")
	speed_up_text.visible = false
	slow_down_text.visible = false
	anim.play("2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if in_range:
		if Input.is_action_just_pressed("interact"):
			is_speeding_up = true
			is_slowing_down = false
			speed_up.emit()
			timer.stop()
			timer.start()
		if Input.is_action_just_released("interact"):
			is_speeding_up = false
			timer.stop()
		if Input.is_action_just_pressed("interact2"):
			is_slowing_down = true
			is_speeding_up = false
			slow_down.emit()
			timer.stop()
			timer.start()
		if Input.is_action_just_released("interact2"):
			is_slowing_down = false
			timer.stop()

func _on_timer_timeout():
	if is_slowing_down:
		slow_down.emit()
		timer.start()
	elif is_speeding_up:
		speed_up.emit()
		timer.start()

func _on_area_2d_area_entered(area):
	if area.is_in_group("protagonistArea"):
		in_range = true
		speed_up_text.visible = true
		slow_down_text.visible = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("protagonistArea"):
		in_range = false
		speed_up_text.visible = false
		slow_down_text.visible = false
