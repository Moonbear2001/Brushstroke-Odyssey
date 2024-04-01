extends Protagonist

"""
Protagonist for the Van Gogh level.
"""

@onready var glow_anim = $Glow

var windDirection = Vector2(-1, 0)
var windForce = -400
var inWind = false
var glow = false
var glow_level = "0"
var refueling_left = false
var refueling_right = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inWind:
		apply_wind_force(delta)

func apply_wind_force(_delta):
	velocity.x = windForce
	velocity.y = -50
	
func get_anim_name(anim_name: String):
	if glow:
		if glow_anim:
			glow_anim.show()
			glow_anim.play(glow_level)
		if int(glow_level) < 5:
			return anim_name + "_dim"
		return anim_name + "_glow"
	else:
		if (refueling_left or refueling_right) and glow_level == "10":
			glow_anim.show()
			glow_anim.play(glow_level)
			return "RefillDone_default"
		elif refueling_left:
			glow_anim.show()
			glow_anim.play(glow_level)
			return "RefillLeft_default"
		elif refueling_right:
			glow_anim.show()
			glow_anim.play(glow_level)
			return "RefillRight_default"
		if glow_anim and not (refueling_left or refueling_right):
			glow_anim.hide()
		return anim_name + "_default"
