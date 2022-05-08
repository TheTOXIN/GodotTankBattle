extends KinematicBody2D

signal health_changed
signal ammo_changed
signal dead 
signal shoot
signal boost 
signal speeder
signal track
signal aim
signal shield

export (PackedScene) var Bullet
export (int) var max_speed
export (float) var max_rotation_speed
export (float) var gun_cooldown
export (int) var max_health
export (float) var offroad_friction

export (float) var turret_speed = PI
export (int) var gun_shots = 1
export (float, 0, 1.5) var gun_spread = 0
export (float) var acceleration = 0.025
export (int) var max_ammo = 20
export (int) var ammo = -1 setget set_ammo

var velocity = Vector2.ZERO
var print_trail = false
var can_shoot = true
var alive = true
var health = 0
var speed = 0
var rotation_speed = 0
var speed_boost = 1.0
var speed_road = 1.0
var map: TileMap
var reload = false
var aim_effect = false
var shield_effect = false
var default_turret_speed
var bullet_boost = 1

func _ready():
	$GunTimer.wait_time = gun_cooldown
	$Turret.offset.x = 20
	$Smoke.emitting = false
	health = max_health
	speed = 0
	rotation_speed = max_rotation_speed
	default_turret_speed = turret_speed
	change_health()
	change_ammo()
	
func _physics_process(delta):
	if not alive:
		return
	control(delta)
	check_offroad()
	var _res = move_and_slide(velocity)
	
func _process(_delta):
	can_shoot = !reload and ammo != 0
	emit_signal("speeder", speed)
	update()

func check_offroad():
	if map:
		var tile = map.get_cellv(map.world_to_map(position))
		if tile in Globals.slow_terrain:
			speed_road = offroad_friction
		else:
			speed_road = 1
			
func take_damage(amount):
	if shield_effect: return
	health -= amount
	health_trigger()
	if health <= 0:
		explode()

func heal(amount):
	health = clamp(health + amount, 0, max_health)
	health_trigger()
	
func health_trigger():
	change_health()
	if health >= max_health / 3:
		$Smoke.emitting = false
		
func change_health():
	emit_signal("health_changed", health * 100 / max_health)
	
func set_ammo(value):
	ammo = clamp(value, -1, max_ammo)
	change_ammo()
	
func change_ammo():
	emit_signal("ammo_changed", ammo * 100 / max_ammo, ammo)

func explode():
	alive = false
	can_shoot = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Turret.hide()
	$Explosion.show()
	$Explosion.play()

func boost(amount):
	emit_signal("boost")
	$BoostTimer.wait_time = amount
	speed_boost = 2
	rotation_speed *= 1.5
	$BoostTimer.one_shot = true
	$BoostTimer.start()
	$Boost.show()

func aim(time):
	emit_signal("aim")
	turret_speed = 1
	bullet_boost = 2
	aim_effect = true
	$GunTimer.wait_time = 0.5
	$AimTimer.wait_time = time
	$AimTimer.one_shot = true
	$AimTimer.start()

func shield(time):
	emit_signal("shield")
	shield_effect = true
	$ShieldTimer.wait_time = time
	$ShieldTimer.one_shot = true
	$ShieldTimer.start()

func shoot(target_pos):
	if can_shoot:
		reload = true
		self.ammo -= 1 
		$GunTimer.start()
		var dir = Vector2.RIGHT.rotated($Turret.global_rotation)
		var pos = $Turret/Muzzle.global_position
		if gun_shots > 1:
			spawn_bullet_shell(pos, dir, target_pos)
		else:
			spawn_bullet(pos, dir, target_pos)
		$AnimationPlayer.play("muzzle_flash")
		
func spawn_bullet_shell(pos, dir, target_pos):
	var bullets = []
			
	for _i in range(gun_shots):
		bullets.append(Bullet.instance())
			
	for i in range(gun_shots):
		bullets[i].shot_shell = bullets
		var a = -gun_spread + i * (2 * gun_spread) / (gun_shots - 1)
		var dir_rotate = dir.rotated(a)
		emit_signal('shoot', bullets[i], pos, dir_rotate, target_pos, self)

func spawn_bullet(pos, dir, target_pos):
	var bullet = Bullet.instance()
	emit_signal('shoot', bullet, pos, dir, target_pos, self)

func head_collide():
	return $LookHead1.is_colliding() or $LookHead2.is_colliding() or $LookHead3.is_colliding()
	
func control(_delta):
	pass

func _on_GunTimer_timeout():
	reload = false

func _on_Explosion_animation_finished():
	queue_free()
	emit_signal("dead")

func _on_BoostTimer_timeout():
	emit_signal("boost")
	speed_boost = 1
	rotation_speed = max_rotation_speed
	$Boost.hide()

func _on_AimTimer_timeout():
	emit_signal("aim")
	turret_speed = default_turret_speed
	$GunTimer.wait_time = gun_cooldown
	bullet_boost = 1
	aim_effect = false

func _on_ShieldTimer_timeout():
	emit_signal("shield")
	shield_effect = false 
