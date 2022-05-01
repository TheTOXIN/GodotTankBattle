extends "res://tanks/Tank.gd"

export (float) var turret_speed
export (int) var detect_radius 

onready var parent = get_parent()

var target: Node2D = null
var speed = 0

func _ready():
	#TODO BLYAT detect_radius
	$DetectRadius/CollisionShape2D.shape = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape.radius = 400

func _process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2.RIGHT.rotated($Turret.global_rotation)
		
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
		#TODO set default
		
		#dot product vectors
		if target_dir.dot(current_dir) > 0.9:
			shoot()
		
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
	# if body.name == "Player": move to physic layer
	target = body

func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null
