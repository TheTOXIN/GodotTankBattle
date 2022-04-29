extends "res://tanks/Tank.gd"

export (float) var turret_speed
export (int) var detect_radius 

onready var parent = get_parent()

var target: Node2D = null

func _ready():
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func _process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2.RIGHT.rotated($Turret.global_rotation)
		
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
		#TODO set default
		
func control(delta):
	if parent is PathFollow2D:
		parent.offset += speed * delta
		position = Vector2.ZERO
	else: 
		pass

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		target = body

func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null
