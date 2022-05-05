extends CanvasLayer

var bar_texture
var show_boost = false

func _on_Player_ammo_changed(value):
	$GUI/Container/AmmoGuage.value = value
	
func _on_Player_health_changed(value):
	bar_texture = Globals.get_bar(value)
	
	var bar = $GUI/Container/HealthBar
	var tween = $GUI/Container/HealthBar/Tween
	
	tween.interpolate_property(
		bar, 'value', bar.value, value, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	
	bar.texture_progress = bar_texture
	
	$AnimationPlayer.play("healthbar_flash")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "healthbar_flash":
		$GUI/Container/HealthBar.texture_progress = bar_texture

func _on_Player_boost():
	print("ЧТО")
	show_boost = !show_boost
	
	if show_boost:
		$AnimationPlayer2.play("flash_boost")
	else:
		$AnimationPlayer2.stop()
	
	$GUI/Container/VBoxContainer/MarginContainer/TextureBoost.visible = show_boost

