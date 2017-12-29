extends RigidBody2D

var WALK_MAX_VELOCITY = 200.0
var is_jumping = false
var programming_mode = false
signal program_block(block_id)

func _integrate_forces(state):
	
	var linear_velocity = state.get_linear_velocity()
	
	#Controls
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var program_tile = Input.is_action_pressed("program_tile")
	
	#Movement
	if(jump and not get_colliding_bodies().empty()):
		for i in range(0, get_colliding_bodies().size()):
			if get_colliding_bodies()[i].get_parent().is_active:
				linear_velocity.y = -500
				is_jumping = true
				break
		
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
	
	if (get_colliding_bodies().size() == 1 and program_tile and not programming_mode):
		
		#Sends signal to program the block (tile)
		emit_signal("program_block", get_colliding_bodies()[0].get_parent().programmable_tiles)
		programming_mode = true
		
func _ready():
	set_max_contacts_reported(2)
	set_contact_monitor(true)