extends Node2D

func _ready():
	set_camera_limits()
	var cursor = load("res://assets/UI/crossair_white.png")
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16, 16))
	$Player.map = $Ground
	
func set_camera_limits():
	var map_limits = $Ground.get_used_rect()
	var map_cell_size = $Ground.cell_size
	
	$Player/Camera2D.limit_left = map_limits.position.x * map_cell_size.x
	$Player/Camera2D.limit_right = map_limits.end.x * map_cell_size.x
	$Player/Camera2D.limit_top = map_limits.position.y * map_cell_size.y
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cell_size.y

func _on_Tank_shoot(bullet, _pos, _dir, _tar = null, _holder = null):
	var b = bullet.instance()
	add_child(b)
	b.start(_pos, _dir, _tar, _holder)
	
func _on_Player_dead():
	Globals.restart()
