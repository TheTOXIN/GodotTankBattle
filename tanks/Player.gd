extends "res://tanks/Tank.gd"

var track_trails = false
var skid = 0

func control(delta):
	$Turret.look_at(get_global_mouse_position())
	
	var rot_dir = 0
	
	if Input.is_action_pressed("turn_right"):
		rot_dir += 1
		skid += 1
	elif Input.is_action_pressed("turn_left"):
		rot_dir -= 1
		skid += 1
	else:
		skid = 0
		pass
	
	rotation += rotation_speed * rot_dir * delta

	var possible_speed = max_speed * speed_boost *  speed_road

	if Input.is_action_pressed("forward"):
		speed = lerp(speed, possible_speed, acceleration)
		velocity = (Vector2.RIGHT * speed).rotated(rotation)
	elif Input.is_action_pressed("back"):
		speed = lerp(speed, possible_speed / 2, acceleration)
		velocity = (Vector2.LEFT * speed).rotated(rotation)
	else:
		velocity = velocity.normalized() * speed
		speed = lerp(speed, 0, acceleration + acceleration)
				
	if Input.is_action_just_pressed("click") or Input.is_action_pressed("ui_select"):
		shoot(null)
		
	if Input.is_action_pressed("restart") and Globals.debag_mode:
		Globals.restart()
		
	position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
	position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)
	
	#make dependency чем больше скорость тем раньше занос, а не сколько повернул
	track_trails = skid >= 30 and speed > 150
	
	if track_trails:
		emit_signal("track", self)
