extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	finished.connect(effect_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func effect_finished():
	queue_free()
