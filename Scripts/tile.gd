extends Sprite

var row
var col
var is_active
var programmable_tiles = []

func set_active():
	set_texture(load("res://tile2.png"))
	get_node("StaticBody2D/CollisionShape2D").set_trigger(false)
	is_active = true
	
func set_inactive():
	set_texture(load("res://tile1.png"))
	get_node("StaticBody2D/CollisionShape2D").set_trigger(true)
	is_active = false

func set_programmable(row, col):
	if (self.row == row and self.col == col):
		set_texture(load("res://tile3.png"))

func init(row, col):
	self.row = row
	self.col = col
	for i in range(3):
		randomize()
		programmable_tiles.push_front([randi()%5+row+1, randi()%8])

func _ready():
	add_to_group("tiles")