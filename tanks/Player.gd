extends "res://tanks/Tank.gd"

var track_trails = false
var speed_stop = 0
var aim_position

func control(delta):
	turret_aim(delta)
	
	var rot_dir = 0
	
	if Input.is_action_pressed("turn_right"):
		rot_dir += 1
	elif Input.is_action_pressed("turn_left"):
		rot_dir -= 1
		
	rotation += rotation_speed * rot_dir * delta

	var possible_speed = max_speed * speed_boost * speed_road
	var possible_back = -1 * (possible_speed) / 2
	
	if Input.is_action_pressed("forward"):
		if Input.is_action_pressed("back"): #DRIFT
			track_trails = true
		else: #FORWARD
			speed = lerp(speed, possible_speed, acceleration)
			
	if Input.is_action_pressed("back"):
		if speed > 0: #STOP
			if speed_stop == 0:
				speed_stop = speed
			var stopper = 300 / pow(speed_stop, 2)
			speed = lerp(speed, possible_back, stopper)
			if speed > 0:
				speed 
			track_trails = true
		else: #BACK
			speed = lerp(speed, possible_back, acceleration)
			pass
		
	velocity = (Vector2.RIGHT * speed).rotated(rotation)
	
	if !Input.is_action_pressed("back") and !Input.is_action_pressed("forward"):
		velocity = (Vector2.RIGHT * speed).rotated(rotation)
		speed = lerp(speed, 0, 0.01)
		track_trails = false
	
	if Input.is_action_just_released("back"):
		track_trails = false
		speed_stop = 0
				
	if Input.is_action_just_pressed("click") or Input.is_action_pressed("ui_select"):
		shoot(null)
		
	if Input.is_action_pressed("restart") and Globals.debag_mode:
		Globals.restart()

	position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
	position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)
	
	if track_trails:
		emit_signal("track", self)

func turret_aim(delta):
	var cursor = get_global_mouse_position()
	var angle_position = cursor - $Turret.global_position
	
	var a = angle_position.angle()
	var r = $Turret.global_rotation

	var angle_turret = lerp_angle(r, a, turret_speed)
	$Turret.global_rotation = angle_turret
	
	#set muzzle aim
	$Turret/Aim.position.x = $Turret.global_position.distance_to(cursor) 
	aim_position = $Turret/Aim.global_position
	$AimSprite.global_position = aim_position
	
	if can_shoot:
		$AimSprite.modulate = Globals.color_green
	else:
		$AimSprite.modulate = Globals.color_red

func _on_Area2D_body_entered(body):
	if head_collide():
		if speed > 200:
			take_damage(5)
		speed = 0
