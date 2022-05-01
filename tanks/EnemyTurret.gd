extends "res://tanks/Enemy.gd"

func _ready():
	$DetectRadius/CollisionShape2D.shape.radius = 500
