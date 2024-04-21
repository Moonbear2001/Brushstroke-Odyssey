extends Level

@onready var death = $Death

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	death.connect("respawn", Callable(self, "respawn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func respawn():
	get_tree().reload_current_scene()

