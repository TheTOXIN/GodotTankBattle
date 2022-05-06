extends Node

var bar_red = preload("res://assets/UI/barHorizontal_red_mid 200.png")
var bar_green = preload("res://assets/UI/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://assets/UI/barHorizontal_yellow_mid 200.png")

var debag_mode = false

var slow_terrain = [0, 10, 20, 30, 7, 8, 17, 18]
var current_level = 0
var levels = [
	"res://UI/TitleScreen.tscn", 
	"res://maps/Map.tscn"
]

var enemy_counter = 0

func restart():
	current_level = 0
	enemy_counter = 0
	change_scene()

func next_level():
	current_level += 1
	if current_level < levels.size():
		change_scene()
	else:
		restart()

func change_scene():
	get_tree().change_scene(levels[current_level])
	
func get_bar(value):
	var bar_texture = Globals.bar_green
	
	if value < 60:
		bar_texture = Globals.bar_yellow
	if value < 30:
		bar_texture = Globals.bar_red
		
	return bar_texture
