extends Node2D

var t: float = 0
var a: float = 0

func _physics_process(delta):
	t += delta * 0.4
	a += 10 * delta
	
	$B.position = $B.position + Vector2(sin(a),  cos(a)) * 5
	$TEST.position = $A.position.linear_interpolate($B.position, t)
	
	#TODO STOP
