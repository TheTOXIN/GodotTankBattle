extends Line2D

export(NodePath) var targetPath

var point
var target
var enable

var counter = 0
var stepper = 5
var length = 10 

func _ready():
	visible = false 
	enable = false
	target = get_node(targetPath)
	pass
	
func _process(delta):
	if !visible: 
		return
		
	global_position = Vector2.ZERO
	global_rotation = 0
	
	if counter >= stepper:
		counter = 0
		point = target.global_position
		add_point(point)
	
	if get_point_count() > length or !enable:
		remove_point(0)
	
	if get_point_count() <= 0 and !enable:
		visible = false 
	
	counter += 1
	pass

func hide():
	enable = false
	pass

func show():
	visible = true
	enable = true
	pass
