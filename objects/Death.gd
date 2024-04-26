extends Area2D

signal respawn

func _on_body_entered(body):
	print("entered death")
	if body.is_in_group("protagonist"):
		respawn.emit()
