extends Node

var slow_terrain = [0, 10, 20, 30, 7, 8, 17, 18]
var current_level = 0
var levels = [
	"res://UI/TitleScreen.tscn", 
	"res://maps/Map01.tscn"
]

func restart():
	current_level = 0
	change_scene()

func next_level():
	current_level += 1
	if current_level < levels.size():
		change_scene()
	else:
		restart()

func change_scene():
	get_tree().change_scene(levels[current_level])
