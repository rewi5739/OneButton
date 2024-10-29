extends Node2D

@onready var selection = $Selection
@onready var elements = $Elements
@onready var goal_elements = $GoalElements
@onready var timer = $Timer
@onready var result_label = $ResultLabel
@export  var BASE_TIME = 4
@export  var BASE_DIFFICULTY = 4
@export  var final_level = 10
@export  var test_sound: Resource
@onready var default_time: float = BASE_TIME
@onready var curr_level = BASE_DIFFICULTY
var particle_scene = preload("res://Scenes/cauldron_particles.tscn")
var elements_arr:Array
var AEIndex : int = 0
var active_element : CharacterBody2D
var chosen_elements:Array = []
var goal : Array
var resetting = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_level()


func next_level():
	#print(chosen_elements)
	timer.stop()
	selection.visible = false
	if curr_level > final_level:
		get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
	if not chosen_elements.is_empty() and elements_arr[chosen_elements[-1]].visible:
		await elements_arr[chosen_elements[-1]].element_added
	var success = check_potion_successful()
	for element in elements_arr:
		element.reset()
	for element in goal_elements.elements():
		element.reset()
	await get_tree().create_timer(0.5).timeout
	chosen_elements = []
	if success:
		play_success()
		curr_level += 1
		if curr_level%3 ==0:
			default_time += 1
	else:
		play_failure()
		curr_level = BASE_DIFFICULTY
		default_time = BASE_TIME
	generate_level(curr_level)
	transition()
	#resetting = false
	#generate_level(difficulty)


func _on_pot_collider_body_entered(body: Node2D) -> void:
	#print("pot body entered")
	generate_particles(body.position, body.get_child(0).texture)
	body.entered_pot()
	ShakeBus.trigger_shake(20, 10)


func _on_timer_timeout() -> void:
	AudioManager.play_sfx(test_sound)
	if not resetting:
		AEIndex = (AEIndex + 1) % elements_arr.size()
		if AEIndex == 0:
			resetting = true
			next_level()
		#print("elements array reset\n", elements_arr)
		active_element = elements_arr[AEIndex]
		selection.select(active_element)
		#print("timer, ", AEIndex)


func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_paste"):
		#print("spaghetti")
	if event.is_action_pressed("main") and not resetting:
		active_element.choose()
		chosen_elements.append(AEIndex)


func generate_level(level : int) -> void:
	ShakeBus.randSeed = randi()
	elements.genertate_elements(level)
	goal_elements.genertate_elements(level)
	goal = []
	for i in level:
		goal.append(randf() <= 0.5)
	goal_elements.set_visibility(goal)
	elements_arr.clear()
	elements_arr = elements.elements()
	#print("elements array reset", elements_arr)
	active_element = elements_arr[AEIndex]
	timer.wait_time = default_time/level
	selection.select(active_element)
	

func generate_particles(effect_position: Vector2, asset):
	var particle_effect = particle_scene.instantiate()
	particle_effect.position = effect_position
	particle_effect.texture = asset
	add_sibling(particle_effect)

func check_potion_successful():
	#print("comparing ", chosen_elements, " to ", goal)
	var i=0
	for b in goal:
		if b:
			if chosen_elements.has(i):
				return false
		i+=1
	if chosen_elements.is_empty() && goal.has(true):
		return false
	return true
	

func transition():
	var transition_timer = get_tree().create_timer(1.0)
	#print(default_time)
	await transition_timer.timeout
	timer.start(default_time/curr_level)
	result_label.visible = false
	await timer.timeout
	print("1")
	await timer.timeout
	print("2")
	await timer.timeout
	print("3")
	await timer.timeout
	print("4")
	await timer.timeout
	selection.visible = true
	resetting = false


func play_success():
	result_label.text = "Success!"
	result_label.visible = true
	#print("success")

func play_failure():
	result_label.text = "Failure!"
	result_label.visible = true
	#print("failure")
