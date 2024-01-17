extends Sprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_scale = scale
	current_scale.x *= -1
	scale = current_scale
