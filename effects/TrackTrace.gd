extends Line2D

export(NodePath) var targetPath

var point
var target
var enable

var counter = 0
var stepper = 10
#TODO TO BOOST
func _ready():
	target = get_node(targetPath)
	pass
	
func _process(delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	
	if counter >= stepper:
		counter = 0
		point = target.global_position
		add_point(point)
		
	counter += 1
	
	pass
