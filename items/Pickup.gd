extends Area2D

enum Items {health, ammo}

export (Items) var type = Items.health
export (Vector2) var amount = Vector2(10, 25)

var icon_textures = {
	Items.health: preload("res://assets/effects/wrench_white.png"),
	Items.ammo: preload("res://assets/effects/ammo_machinegun.png")
}

func _ready():
	$Icon.texture = icon_textures[type]

#TODO WTF
func _on_Pickup_body_entered(body):
	match type:
		Items.health:
			if body.has_method('heal'):
				var t = int(rand_range(amount.x, amount.y))
				print(t)
				body.heal(t)
		Items.ammo:
			var t = int(rand_range(amount.x, amount.y))
			print(t)
			body.ammo += t
	queue_free()
