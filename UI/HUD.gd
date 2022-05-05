extends CanvasLayer

var bar_texture
var show_boost = false

func _ready():
	$GUI/Container/Effects/EffectBoost.visible = false

func _on_Player_ammo_changed(value, count):
	$GUI/Container/Bars/BulletsBar/Count/Background/Number.text = str(count)
	$GUI/Container/Bars/BulletsBar/Progress.value = value
	
func _on_Player_health_changed(value):
	bar_texture = Globals.get_bar(value)
	
	var bar = $GUI/Container/Bars/HealthBar/Progress
	var tween = $GUI/Container/Bars/HealthBar/Progress/Tween
	
	tween.interpolate_property(
		bar, 'value', bar.value, value, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	
	bar.texture_progress = bar_texture
	
	$AnimationPlayer.play("healthbar_flash")
	$GUI/Container/Bars/HealthBar/Count/Background/Number.text = str(value)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "healthbar_flash":
		$GUI/Container/Bars/HealthBar/Progress.texture_progress = bar_texture

func _on_Player_boost():
	show_boost = !show_boost
	$GUI/Container/Effects/EffectBoost.visible = show_boost

func _on_Player_speeder(speed):
	$GUI/Container/Speed/Label.text = str(int(speed)) + " / MPH"
