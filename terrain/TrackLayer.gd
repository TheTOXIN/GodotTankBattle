extends Node2D

var tracks = []
var counter = 0
var stepper = 5

var texture: Texture

func _ready():
	$Timer.wait_time = 1
	texture = $Sprite.texture
	pass
	
func _process(delta):
	update()
	pass

#MAGIC
func _draw():
	for track in tracks:
		var pos = Vector2(track.pos.x - 70, track.pos.y - 41)
		var origin = (texture.get_size() * 0.5).rotated(track.rot + 5/4 * PI)
		draw_set_transform(origin, track.rot, Vector2.ONE)
		draw_texture(texture, track.pos.rotated(-track.rot))
	pass
	
func draw_track(tank):
	if counter >= stepper:
		var track = TrackData.new(tank.global_position, tank.global_rotation)
		tracks.append(track)
		if tracks.size() >= 100:
			tracks.remove(0)
			$Timer.start()
		counter = 0
	counter += 1

func _on_Timer_timeout():
	tracks.remove(0)	

class TrackData:
	var pos
	var rot
	
	func _init(_pos, _rot):
		pos = _pos
		rot = _rot
