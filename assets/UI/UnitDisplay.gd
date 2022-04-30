extends Node2D

#TODO refacor with HUD

var bar_red = preload("res://assets/UI/barHorizontal_red_mid 200.png")
var bar_green = preload("res://assets/UI/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://assets/UI/barHorizontal_yellow_mid 200.png")

func _ready():
	for node in get_children():
		node.hide()

func _process(delta):
	global_rotation = 0
	
func _on_Enemy_health_changed(value):
	var bar_texture = bar_green
	
	if value < 60:
		bar_texture = bar_yellow
	if value < 30:
		bar_texture = bar_red
	
	if value < 100:
		$HealthBar.show()
	
	$HealthBar.texture_progress = bar_texture
	$HealthBar.value = value
