extends CanvasLayer


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("main"):
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
