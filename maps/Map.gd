extends Node2D
#reload, sounds, DESTROY OBJECTS

signal enemy_counter

func _ready():
	set_camera_limits()
	var cursor = load("res://assets/UI/crossair_white.png")
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16, 16))
	$Player.map = $Ground

func _process(delta):
	emit_signal("enemy_counter", Globals.enemy_counter)
	if Globals.enemy_counter == 0:
		Globals.restart()
#	if Globals.debag_mode:
#		print(Engine.get_frames_per_second())

func set_camera_limits():
	var map_limits = $Ground.get_used_rect()
	var map_cell_size = $Ground.cell_size
	
	$Player/Camera2D.limit_left = map_limits.position.x * map_cell_size.x
	$Player/Camera2D.limit_right = map_limits.end.x * map_cell_size.x
	$Player/Camera2D.limit_top = map_limits.position.y * map_cell_size.y
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cell_size.y

func _on_Tank_shoot(bullet, _pos, _dir, target_pos, holder):
	add_child(bullet)
	bullet.start(_pos, _dir, target_pos, holder)
	
func _on_Player_dead():
	Globals.restart()

func _on_Player_track(tank):
	$TrackLayer.draw_track(tank)
