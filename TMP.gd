extends Node2D

var t: float = 0
var a: float = 0

func _physics_process(delta):
	t += delta * 0.4
	a += 10 * delta

	$B.position = $B.position + Vector2(sin(a),  cos(a)) * 10
	$TEST.position = $A.position.linear_interpolate($B.position, t)

	if $TEST.position >= $B.position:
		$TEST.position = $B.position
	
	$A.rotation = ($B.position - $A.position).angle()

	update()
		
func _draw():
	var v1 = $A.position
	var v2 = ($TEST.position - $A.position) + $A.position
	
	draw_line(Vector2.ZERO + $A.position, v2 , Color.black, 5)
	draw_circle(v2, 10, Color.black)
	
