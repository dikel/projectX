extends Node

onready var tile = preload("res://Scenes/Tile.tscn")
var row = 1
signal more_rows(new_rows)

func _ready():
	#Generate the first row
	for i in range(8):
		var s = tile.instance()
		s.init(0, i)
		s.set_pos(Vector2(i*128, 0))
		add_child(s)
		if (i % 2 == 0):
			s.set_active()
		else:
			s.set_inactive()
		
	generate_more_rows(10)
	
	connect("more_rows", self, "more_rows_handler")
	var player = get_node("Player")
	player.connect("more_rows", self, "more_rows_handler")

func generate_more_rows(rows):
	for i in range(rows):
		for j in range(8):
			var s = tile.instance()
			s.init(row, j)
			s.set_pos(Vector2(j*128, row*96))
			add_child(s)
			s.set_inactive()
		row += 1
		
func more_rows_handler(new_rows):
	generate_more_rows(new_rows)