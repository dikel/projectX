extends Sprite

var row
var col
var is_active
var defining_tiles = []
var defining_mode = false

func set_active():
	set_texture(load("res://Textures/active_tile.png"))
	get_node("StaticBody2D/CollisionShape2D").set_trigger(false)
	is_active = true
	
func set_inactive():
	set_texture(load("res://Textures/inactive_tile.png"))
	get_node("StaticBody2D/CollisionShape2D").set_trigger(true)
	is_active = false

func set_defining_mode(row, col):
	if (self.row == row and self.col == col):
		set_texture(load("res://Textures/defining_tile.png"))
		defining_mode = true

func set_normal():
	if (is_active):
		set_active()
	else:
		set_inactive()

func init(row, col):
	self.row = row
	self.col = col
	for i in range(3):
		randomize()
		defining_tiles.push_front([randi()%5+row+1, randi()%8])

func _ready():
	add_to_group("tiles")
	set_process_input(true)

func _input(event):
	var mouse_pos = get_global_mouse_pos() + Vector2(61, 45)
	if(event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_LEFT and defining_mode):
		if(mouse_pos.x > get_pos().x and mouse_pos.y > get_pos().y and mouse_pos.x < get_pos().x + 128 and mouse_pos.y < get_pos().y + 96):
			set_active()
			defining_mode = false
			get_parent().get_node("Player").defining_mode = false
			get_parent().get_tree().call_group(0, "tiles", "set_normal")
	