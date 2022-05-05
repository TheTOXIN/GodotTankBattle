extends "res://tanks/Tank.gd"

export (bool) var disable = false
export (float) var turret_speed
export (int) var detect_radius 
export (float) var accuracy_shoot = 0.9
export (bool) var ghost = false 

onready var parent = get_parent()

var target: Node2D = null
var hit_pos: Array = []

func _ready():
	$DetectRadius/CollisionShape2D.shape = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	enemy_counter_trigger(1)

func _draw():
	if Globals.debag_mode:
		draw_circle(Vector2.ZERO, detect_radius, Color(0, 0, 0, 0.25))
		if target:
			for hit in hit_pos:
				var v = (hit - global_position).rotated(-global_rotation)
				draw_circle(v, 5, Color.red)
				draw_line(Vector2.ZERO, v, Color.red, 3)
			
func _process(delta):
	if !target or disable:
		return
	
	hit_pos = []
	
	var space_state = get_world_2d().direct_space_state;
	var ray_cast = ray_cast_points()
	
	for check_pos in ray_cast:
		var result = space_state.intersect_ray(global_position, check_pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.name == "Player":
				targeting(result.position, delta)
				break #oprimze ray cast
	update()

func ray_cast_points():
	var collision_shape = target.get_node('CollisionShape2D')
	
	var target_extents = collision_shape.shape.extents - Vector2(5, 5)
	var shape_rotate  = collision_shape.global_rotation

	var nw = target.position - target_extents.rotated(shape_rotate)
	var se = target.position + target_extents.rotated(shape_rotate)
	var ne = target.position + Vector2(target_extents.x, -target_extents.y).rotated(shape_rotate)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y).rotated(shape_rotate)
	
	return [target.position, nw, se, ne, sw]

func targeting(target_pos, delta):
	var target_dir = (target_pos - global_position).normalized()
	var current_dir = Vector2.RIGHT.rotated($Turret.global_rotation)
		
	var v = current_dir.linear_interpolate(target_dir, turret_speed * delta)
	$Turret.global_rotation = v.angle()

	#dot product vectors
	if target_dir.dot(current_dir) > accuracy_shoot:
		shoot(target_pos)

func control(delta):
	if parent is PathFollow2D:
		if $LookHead1.is_colliding() or $LookHead2.is_colliding():
			speed = lerp(speed, 0, 0.1)
		else: 
			speed = lerp(speed, max_speed, acceleration)
		parent.offset += speed * delta
		position = Vector2.ZERO
	else:
		#other movement
		pass

func explode():
	if alive:
		alive = false
		enemy_counter_trigger(-1)
		.explode()
	
func enemy_counter_trigger(val):
	if !ghost:
		Globals.enemy_counter += val

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		target = body

func _on_DetectRadius_body_exited(body):
	if body.name == "Player":
		target = null
