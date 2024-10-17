extends CharacterBody2D

signal element_added
var starting_pos :Vector2
const SPEED = 30.0
var chosen = false


func _physics_process(delta: float) -> void:
	
	if chosen:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		var collision: KinematicCollision2D = move_and_collide(velocity)
		if (collision):
			print(collision.get_normal())
			velocity += collision.get_normal() * 50
	

func choose():
	chosen = true

func entered_pot():
	element_added.emit()
	visible = false

func reset():
	queue_free()
