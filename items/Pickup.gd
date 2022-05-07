extends Area2D

enum Items {health, ammo, boost, aim}

export (Items) var type = Items.health
export (Vector2) var amount = Vector2(10, 25)

var icon_textures = {
	Items.health: preload("res://assets/effects/wrench_white.png"),
	Items.ammo: preload("res://assets/effects/ammo_machinegun.png"),
	Items.boost: preload("res://assets/effects/boost_whie.png"),
	Items.aim: preload("res://assets/effects/reloader_whie.png")
}

var rand = RandomNumberGenerator.new()

func _ready():
	$Icon.texture = icon_textures[type]
	rand.randomize()
	
func _on_Pickup_body_entered(body):
	match type:
		Items.health:
			if body.has_method('heal'):
				body.heal(rand.randi_range(amount.x, amount.y))
		Items.ammo:
			body.ammo += rand.randi_range(amount.x, amount.y)
		Items.boost:
			body.boost(rand.randi_range(5, 10))
		Items.aim:
			print("FAST RELOAD") #TODO FAST RELOAD AND AIM RAY
	queue_free()
