extends Node2D

var t: float = 0
var a: float = 0

var v1: Vector2 = Vector2.ZERO
var v2: Vector2 = Vector2.ZERO

func _physics_process(delta):
	t += delta * 0.4
	a += 10 * delta

	$B.position = $B.position + Vector2(sin(a),  cos(a)) * 5
	$TEST.position = $A.position.linear_interpolate($B.position, t)
	
	if $TEST.position >= $B.position:
		$TEST.position = $B.position

	var r = $A.rotation
	$A.rotation += 2 * delta
		
	v1 = $A.position
	v2 = $A.position + Vector2(sin(-r), cos(r)) * 150

	update()
		
func _draw():
	draw_line(v1, v2, Color.black, 5)
	draw_circle(v2, 10, Color.black)
	
