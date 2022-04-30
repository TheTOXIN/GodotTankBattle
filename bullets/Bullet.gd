extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime

var velocity = Vector2.ZERO

func start(_position: Vector2, _direction: Vector2):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	
func explode():
	velocity = Vector2.ZERO
	$Sprite.hide()
	$Explosion.show()
	$Explosion.play("smoke")

func _process(delta):
	position += velocity * delta

func _on_Bullet_body_entered(body):
	explode()
	if body.has_method('take_damage'):
		body.take_damage(damage)

func _on_Lifetime_timeout():
	explode()

func _on_Explosion_animation_finished():
	queue_free()
