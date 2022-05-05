extends Node2D

func _ready():
	for node in get_children():
		node.hide()

func _process(delta):
	global_rotation = 0
	
func _on_Enemy_health_changed(value):
	var bar_texture = Globals.get_bar(value)
	
	if value < 100:
		$HealthBar.show()
	
	$HealthBar.texture_progress = bar_texture
	$HealthBar.value = value
