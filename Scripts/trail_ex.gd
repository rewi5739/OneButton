extends Line2D
class_name Trail

var point_queue : Array
@export var max_length: int = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var pos = global_position
	
	point_queue.push_front(pos)
	if point_queue.size() > max_length:
		point_queue.pop_back()
	
	clear_points()
	
	for point in point_queue:
		add_point(point - global_position)
		

#var tween
#func run_tween():
	#if tween: tween.kill()
	#
	#tween = create_tween()
	#tween.tween_property(self, "position", Vector2(300, 300), 1).set_trans(Tween.TRANS_LINEAR)
	#tween.tween_property(self, "position", Vector2(0, 0), 1).set_trans(Tween.TRANS_LINEAR)
	#
