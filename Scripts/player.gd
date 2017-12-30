extends RigidBody2D

onready var camera = get_node("Camera2D")
var WALK_MAX_VELOCITY = 200.0
var is_jumping = false
var programming_mode = false
var is_falling = false
var jumping_start_time = 0
var defining_mode = false
var lowest_row = 0

signal more_rows(new_rows)

func _integrate_forces(state):
	
	#Get FPS (If you feel lag)
	#print(str(OS.get_frames_per_second()))
	
	var linear_velocity = state.get_linear_velocity()
	
	#Controls
	var move_camera_up = Input.is_action_pressed("camera_up")
	var move_camera_down = Input.is_action_pressed("camera_down")
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var show_options = Input.is_action_pressed("show_options")
	
	#Movement
	if(jump and not get_colliding_bodies().empty()):
		for i in range(get_colliding_bodies().size()):
			if (get_colliding_bodies()[i].get_parent().is_active and abs( (get_pos().y) + 77) - get_colliding_bodies()[i].get_parent().get_pos().y < 2):
				linear_velocity.y = -500
				break
	
	if (get_colliding_bodies().empty()):
		falling()
	else:
		for i in range(get_colliding_bodies().size()):
			if(get_colliding_bodies()[i].get_parent().is_active):
				is_falling = false
				if (get_colliding_bodies()[i].get_parent().row > lowest_row):
					emit_signal("more_rows", get_colliding_bodies()[0].get_parent().row - lowest_row)
					lowest_row = get_colliding_bodies()[0].get_parent().row
				break
			falling()
			
	
	if(move_left):
		linear_velocity.x = -200
	if (move_right):
		linear_velocity.x = 200
	if (not move_left and not move_right):
		linear_velocity.x = 0
	state.set_linear_velocity(linear_velocity)
	
	#Prevent rotation
	if (get_rot() != 0):
		set_rot(0)
	if (show_options and not defining_mode):
		var count = 0
		var tile_num
		for i in range(get_colliding_bodies().size()):
			if (get_colliding_bodies()[i].get_parent().is_active):
				count += 1
				tile_num = i
		if (count == 1):
			defining_mode = true
			#Sends signal to program the block (tile)
			var tiles = get_colliding_bodies()[tile_num].get_parent().defining_tiles
			for i in range(tiles.size()):
				get_parent().get_tree().call_group(0, "tiles", "set_defining_mode", tiles[i][0], tiles[i][1])
		
	if(move_camera_up):
		camera.set_pos(camera.get_pos() - Vector2(0, 35))
	if(move_camera_down):
		camera.set_pos(camera.get_pos() + Vector2(0, 35))
		
func falling():
	if (is_falling == false):
		jumping_start_time = OS.get_ticks_msec()
	is_falling = true
	if (OS.get_ticks_msec() - jumping_start_time > 3000):
		print("GAME OVER")
		print("Score: ", lowest_row)
		get_parent().get_tree().reload_current_scene()
		
func _ready():
	set_max_contacts_reported(4)
	set_contact_monitor(true)
	