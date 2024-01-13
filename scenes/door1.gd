extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	var targetNode : Area2D = $%Door2  # Replace with the actual path to your Area2D node
	var xCoordinate : float = targetNode.global_position.x
	var yCoordinate : float = targetNode.global_position.y

	# Assuming 'body' is another node you want to set the coordinates on
	body.global_position.x = xCoordinate + 50
	body.global_position.y = yCoordinate

