extends Node

export(NodePath) var player_path

var player
var bar_texture
var show_boost = false
var show_aim = false
var show_reload = false
var reload_time = 0
var show_shield = false

func _ready():
	if player_path:
		player = get_node(player_path)
		reload_time = player.gun_cooldown
	$HUD/GUI/Container/Effects/EffectBoost.visible = false
	$HUD/GUI/Container/Effects/EffectAim.visible = false
	$HUD/GUI/Container/Effects/EffectShield.visible = false

func _process(_delta):
	if player: 
		draw_reload()

func _on_Player_ammo_changed(value, count):
	$HUD/GUI/Container/Bars/BulletsBar/Count/Background/Number.text = str(count)
	$HUD/GUI/Container/Bars/BulletsBar/Progress.value = value
	
func _on_Player_health_changed(value):
	bar_texture = Globals.get_bar(value)
	
	var bar = $HUD/GUI/Container/Bars/HealthBar/Progress
	var tween = $HUD/GUI/Container/Bars/HealthBar/Progress/Tween
	
	tween.interpolate_property(
		bar, 'value', bar.value, value, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	
	bar.texture_progress = bar_texture
	
	$Timer.start()
	$HUD/GUI/Container/Bars/HealthBar/AnimationPlayer.play("healthbar_flash")
	$HUD/GUI/Container/Bars/HealthBar/Count/Background/Number.text = str(value)
	
func _on_Player_boost():
	show_boost = !show_boost
	$HUD/GUI/Container/Effects/EffectBoost.visible = show_boost

func _on_Player_speeder(speed):
	$HUD/GUI/Container/Speed/Label.text = str(int(speed)) + " / MPH"

func _on_Map01_enemy_counter(count):
	$HUD/GUI/Container/Enemies/Label.text = str(int(count)) + " TANKS"

func _on_Timer_timeout():
	$Timer.stop()
	$HUD/GUI/Container/Bars/HealthBar/Progress.texture_progress = bar_texture

func draw_reload():
	if player.reload and !show_reload:
		start_reload()
		show_reload = true

	if !player.reload and show_reload:
		show_reload = false

	var size = $ReloadProgress.rect_size
	var rect = Vector2(player.aim_position.x - size.x / 2, player.aim_position.y - size.y / 2)
	
	$ReloadProgress.rect_global_position = rect
	$ReloadProgress.visible = show_reload

func start_reload():
	$ReloadProgress.value = 0
	$ReloadProgress/Tween.interpolate_property(
		$ReloadProgress, 'value', $ReloadProgress.value, 100, reload_time
	)
	$ReloadProgress/Tween.start()

func _on_Player_aim():
	show_aim = !show_aim
	$HUD/GUI/Container/Effects/EffectAim.visible = show_aim

func _on_Player_shield():
	show_shield = !show_shield
	$HUD/GUI/Container/Effects/EffectShield.visible = show_shield
