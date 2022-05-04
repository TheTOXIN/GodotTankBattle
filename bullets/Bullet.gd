extends Area2D

export (int) var speed # max speed
export (int) var damage
export (float) var lifetime
export (float) var steer_force = 0

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var target: Node2D = null
var holder: Node2D = null

func start(_position: Vector2, _direction: Vector2, _target = null, _holder = null):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	target = _target
	holder = _holder
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	
func explode():
	velocity = Vector2.ZERO
	$Sprite.hide()
	$Explosion.show()
	$Explosion.play("smoke")

func seek():
	#same operations TODO HMMMMMMMMMMMMM
	var desired: Vector2 = (target.position - position).normalized() * speed
	var steer: Vector2 = velocity.direction_to(desired) * steer_force
	return steer

func take_damage(damage):
	explode()

func _process(delta):
	if target:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
	position += velocity * delta

func _on_Bullet_body_entered(body):
	if body == holder:
		return
	explode()
	if body.has_method('take_damage'):
		body.take_damage(damage)

func _on_Lifetime_timeout():
	explode()

func _on_Explosion_animation_finished():
	queue_free()

#dirty hack for area bullet damage
#udp: its not working when multiply bullets with big collision :(
func _on_Bullet_area_entered(area):
	if area.has_method('take_damage'):
		area.take_damage(damage)
