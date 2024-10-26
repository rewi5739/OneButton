extends Node2D

@onready var start_pos = $Start.position
@onready var end_pos = $End.position
@onready var collection = $Collection
var element_scene = preload("res://Scenes/element.tscn")


var dir_name = "res://Assets/Ingredients/"
var dir : DirAccess = DirAccess.open(dir_name)
var file_names : PackedStringArray = dir.get_files()


func genertate_elements(num_el:int):
	#print(" ".join(file_names))
	if num_el <= 0:
		print("Error: 0 or neg entered to elements.generate_elements")
		get_tree().quit(1)
	elif num_el == 1:
		var new_element = element_scene.instantiate()
		new_element.position = start_pos
		collection.add_child(new_element)
	else:
		var offset:Vector2 = (end_pos - start_pos)/(num_el-1)
		var new_element:CharacterBody2D
		for i in num_el:
			var res = get_rand_asset(i)
			new_element = element_scene.instantiate()
			new_element.get_child(0).texture = res
			new_element.position = start_pos + i*offset
			collection.add_child(new_element)

func elements():
	return $Collection.get_children()

func set_visibility(vis_arr: Array):
	var elements_arr = $Collection.get_children()
	for i in vis_arr.size():
		if vis_arr[i]:
			#TODO: implement different fucntion to make elements not completely dissapear. 
			elements_arr[i].visible = false

func get_rand_asset(i: int):
	#var random_file_ind = floor(randf() * file_names.size())
	var random_file_ind = rand_from_seed(ShakeBus.randSeed + i)[0] % file_names.size()
	var file_path = dir_name + file_names[random_file_ind]
	if file_path.contains("import"):
		file_path = file_path.replace(".import", "")
	#print(file_path)
	var res = load(file_path)
	return res
