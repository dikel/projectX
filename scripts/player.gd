extends RigidBody2D

var WALK_MAX_VELOCITY = 200.0

func _integrate_forces(state):
	
	var linear_velocity = state.get_linear_velocity()
	var step = state.get_step()
	
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	
	print(linear_velocity.x)
	
	if(move_left):
		print("asd")
		linear_velocity.x = -100
		print(linear_velocity.x)
	elif (move_right):
		print("dsa")
		linear_velocity.x = 100
		print(linear_velocity.x)
		
	state.set_linear_velocity(linear_velocity)

func _ready():
	set_process_input(true)
	set_process(true)
	pass
