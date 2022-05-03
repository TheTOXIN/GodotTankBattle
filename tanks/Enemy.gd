extends "res://tanks/Tank.gd"

export (bool) var disable = false
export (float) var turret_speed
export (int) var detect_radius 
export (float) var accuracy_shoot = 0.9

onready var parent = get_parent()

var hit_pos: Vector2 = Vector2.ZERO
var target: Node2D = null
var speed = 0

#TODO 1 HOW RAY TO WROK
#TODO 2 NOW DROW RAY WHEN EXITED
#TODO 3 BROBLEMS WITH MOVE TANKS RAY

func _ready():
	$DetectRadius/CollisionShape2D.shape = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func _draw():
	if Globals.debag_mode:
		draw_circle(Vector2.ZERO, detect_radius, Color(0, 0, 0, 0.25))
		if target:
			var v = (hit_pos - global_position).rotated(-global_rotation)
			draw_circle(v, 5, Color.red)
			draw_line(Vector2.ZERO, v, Color.red, 3)
			
func _process(delta):
	if !target or disable:
		return
		
	var result = get_world_2d().direct_space_state.intersect_ray(
		position, target.position, [self], collision_mask
	)

	if result:
		hit_pos = result.position
		if result.collider.name == "Player":
			targeting(delta)
			
	update()

func targeting(delta):
	var target_dir = (target.global_position - global_position).normalized()
	var current_dir = Vector2.RIGHT.rotated($Turret.global_rotation)
##		
	var v = current_dir.linear_interpolate(target_dir, turret_speed * delta)
	$Turret.global_rotation = v.angle()

	#dot product vectors
	if target_dir.dot(current_dir) > accuracy_shoot:
		shoot(gun_shots, gun_spread, target)

func control(delta):
	if parent is PathFollow2D:
		if $LookHead1.is_colliding() or $LookHead2.is_colliding():
			speed = lerp(speed, 0, 0.1)
		else: 
			speed = lerp(speed, max_speed, 0.05)
		parent.offset += speed * delta
		position = Vector2.ZERO
	else:
		#other movement
		pass

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		target = body

func _on_DetectRadius_body_exited(body):
	if body.name == "Player":
		target = null
