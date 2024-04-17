extends Area2D

signal respawn

func _on_body_entered(body):
	if body.is_in_group("protagonist"):
		respawn.emit()
