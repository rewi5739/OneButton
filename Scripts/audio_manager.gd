extends AudioStreamPlayer2D

var current_track_name : String = ""
#var current_music_track : AudioStream
var usr_vol: float = 1
var childList = []


#func _input(event: InputEvent):
	#if event.is_action_pressed("vol_up"):
		#usr_vol += 5
		#print("audio up" + str(usr_vol))
		#thing()
	#if event.is_action_pressed("vol_down"):
		#usr_vol -= 5
		#print("audio down" + str(usr_vol))
		#thing()

func play_track(new_stream : AudioStream):
	if (stream == new_stream):
		return
	
	stream = new_stream
	set_volume_db(usr_vol)
	play()

func play_sfx(new_stream : AudioStream):
	var sfx_player = AudioStreamPlayer2D.new()
	sfx_player.stream = new_stream
	sfx_player.volume_db = usr_vol
	sfx_player.name = "SFX_Instance"
	add_child(sfx_player)
	sfx_player.play()
	
	#gets called every frame trying to get the signal
	await sfx_player.finished
	sfx_player.queue_free()

#func thing():
	##TODO: don't think this works yet, please fix
	#set_volume_db(usr_vol)
	#for child in get_children():
		#child.set_volume_db(usr_vol)
