extends KinematicBody2D

signal health_changed
signal dead 
signal shoot

export (PackedScene) var Bullet
export (int) var max_speed
export (float) var rotation_speed
export (float) var gun_cooldown
export (int) var max_health

var velocity = Vector2()
var can_shoot = true
var alive = true
var health = 0

func _ready():
	$GunTimer.wait_time = gun_cooldown
	$Turret.offset.x = 20
	
	health = max_health
	change_health()
	
func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_slide(velocity)
	
func take_damage(amount):
	health -= amount
	change_health()
	if health <= 0:
		explode()
	
func change_health():
	emit_signal("health_changed", health * 100 / max_health)
	
func explode():
	alive = false
	can_shoot = false
	$CollisionShape2D.disabled = true
	$Turret.hide()
	$Explosion.show()
	$Explosion.play()
	
func shoot():
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		var dir = Vector2.RIGHT.rotated($Turret.global_rotation)
		var pos = $Turret/Muzzle.global_position
		emit_signal('shoot', Bullet, pos, dir)
		$AnimationPlayer.play("muzzle_flash")
	
func control(delta):
	pass

func _on_GunTimer_timeout():
	can_shoot = true

func _on_Explosion_animation_finished():
	queue_free()
	emit_signal("dead")
