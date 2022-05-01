extends "res://tanks/Tank.gd"

func control(delta):
	#TODO make manually
	$Turret.look_at(get_global_mouse_position())

	var rot_dir = 0
	
	if Input.is_action_pressed("turn_right"):
		rot_dir += 1
	if Input.is_action_pressed("turn_left"):
		rot_dir -= 1
	
	#TODO use tile offroad
	rotation += rotation_speed * rot_dir * delta
	
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("forward"):
		velocity = (Vector2.RIGHT * max_speed).rotated(rotation)
	if Input.is_action_pressed("back"):
		velocity = (Vector2.LEFT * max_speed / 2).rotated(rotation)
		
	if Input.is_action_just_pressed("click"):
		shoot()
		
	position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
	position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)
