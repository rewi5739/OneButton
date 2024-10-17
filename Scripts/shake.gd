extends Camera2D

@export var shake_strength: float = 33.0
@export var fade_rate: float = 5.0

var rng = RandomNumberGenerator.new()
var current_strength :float = 0

func _ready() -> void:
	ShakeBus.shake_triggered.connect(do_shake)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_strength > 0.0:
		current_strength = lerp(current_strength, 0.0, fade_rate*delta)
		offset = Vector2(rng.randf_range(-current_strength, current_strength), rng.randf_range(-current_strength, current_strength))


func do_shake(strength, fade):
	fade_rate = fade
	current_strength = strength
