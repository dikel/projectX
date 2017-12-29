extends Node

onready var tile = preload("res://Scenes/Tile.tscn")
var row = 1

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
	generate_more_rows()

func generate_more_rows():
	for i in range(8):
		for j in range(8):
			var s = tile.instance()
			s.init(row, j)
			s.set_pos(Vector2(j*128, row*96))
			add_child(s)
			s.set_inactive()
		row += 1