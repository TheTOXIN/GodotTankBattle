extends Node 

var tile_size = 128
onready var texture = $Sprite.texture

func _ready():
	var texture_width = texture.get_width() / tile_size
	var texture_height = texture.get_height() / tile_size
	
	var ts = TileSet.new()
	
	for x in range(texture_width):
		for y in range(texture_height):
			var reg = Rect2(x * tile_size, y * tile_size, tile_size, tile_size)
			var id = x + y * 10
			
			ts.create_tile(id)
			ts.tile_set_texture(id, texture)
			ts.tile_set_region(id, reg)
	ResourceSaver.save("res://terrain/terrain_tiles.tres", ts)
	
			
