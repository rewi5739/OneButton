extends Node2D

@onready var selection = $Selection
@onready var elements = $Elements
@onready var goal_elements = $GoalElements
@onready var timer = $Timer
@export var difficulty = 4
@export var default_time:float = 4
var elements_arr:Array
var AEIndex : int = 0
var active_element : CharacterBody2D
var chosen_elements:Array = []
var goal : Array
var resetting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_level(difficulty)


func next_level():
	#print(chosen_elements)
	if not chosen_elements.is_empty() and elements_arr[chosen_elements[-1]].visible:
		await elements_arr[chosen_elements[-1]].element_added
	for element in elements_arr:
		element.reset()
	for element in goal_elements.elements():
		element.reset()
	await timer.timeout
	resetting = false
	chosen_elements = []
	difficulty += 1
	if difficulty%3 ==0:
		default_time += 1
	generate_level(difficulty)


func _on_pot_collider_body_entered(body: Node2D) -> void:
	#print("pot body entered")
	body.entered_pot()
	ShakeBus.trigger_shake(20, 10)


func _on_timer_timeout() -> void:
	if not resetting:
		AEIndex = (AEIndex + 1) % elements_arr.size()
		if AEIndex == 0:
			resetting = true
			next_level()
		#print("elements array reset\n", elements_arr)
		active_element = elements_arr[AEIndex]
		selection.select(active_element)
		print("timer, ", AEIndex)


func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_paste"):
		#print("spaghetti")
	if event.is_action_pressed("main") and not resetting:
		active_element.choose()
		chosen_elements.append(AEIndex)


func generate_level(level : int) -> void:
	elements.genertate_elements(level)
	goal_elements.genertate_elements(level)
	goal = []
	for i in level:
		goal.append(randf() <= 0.5)
	goal_elements.set_visibility(goal)
	elements_arr.clear()
	elements_arr = elements.elements()
	print("elements array reset", elements_arr)
	active_element = elements_arr[AEIndex]
	selection.select(active_element)
	timer.wait_time = default_time/level
	
