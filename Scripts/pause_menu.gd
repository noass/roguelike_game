extends Control

var menu_pause = false
var added_upgrades_in_debug_select = false

func _process(_delta):
	if Input.is_action_just_pressed("MENU") and !menu_pause and !GameManager.dead:
		menu_pause = true
		if !get_parent().get_node("LevelUpGUI").visible:
			get_tree().paused = true
		show()
	elif Input.is_action_just_pressed("MENU") and menu_pause and !GameManager.dead:
		menu_pause = false
		if !get_parent().get_node("LevelUpGUI").visible:
			get_tree().paused = false
		hide()
		
	if GameManager.dead:
		$Panel/TitleText.text = "YOU DIED!"
		$Panel/TitleText.add_theme_color_override("font_color", Color.RED)
		menu_pause = true
		show()
		get_tree().paused = true
		
	if not added_upgrades_in_debug_select:
		for i in Upgrades.stats:
			$DebugMenu/ScrollContainer/VBoxContainer/SelectUpgrade.add_item(i)
		added_upgrades_in_debug_select = true

func reset_script():
	var game_manager = GameManager
	var upgrades = Upgrades
	
	var scriptGameManager = game_manager.get_script()
	var scriptUpgrades = upgrades.get_script()
	
	game_manager.set_script(null)
	game_manager.set_script(scriptGameManager)
	upgrades.set_script(null)
	upgrades.set_script(scriptUpgrades)

func _on_restart_btn_pressed():
	$"../selectSound".pitch_scale = randf_range(0.8, 1.2)
	$"../selectSound".play()
	get_tree().paused = false
	get_tree().reload_current_scene()
	reset_script()

func _on_check_box_toggled(toggled_on):
	$"../selectSound".pitch_scale = randf_range(0.8, 1.2)
	$"../selectSound".play()
	if toggled_on:
		GameManager.invincible = true
	else:
		GameManager.invincible = false

func _on_gain_level_btn_pressed():
	$"../selectSound".pitch_scale = randf_range(0.8, 1.2)
	$"../selectSound".play()
	GameManager.curr_xp = GameManager.xp_needed_for_lvl_up

func _on_gain_reroll_btn_pressed():
	$"../selectSound".pitch_scale = randf_range(0.8, 1.2)
	$"../selectSound".play()
	get_parent().remaining_rerolls += 1

func _on_set_btn_pressed():
	$"../selectSound".pitch_scale = randf_range(0.8, 1.2)
	$"../selectSound".play()
	Upgrades.stats[$DebugMenu/ScrollContainer/VBoxContainer/SelectUpgrade.get_item_text($DebugMenu/ScrollContainer/VBoxContainer/SelectUpgrade.selected)] = $DebugMenu/ScrollContainer/VBoxContainer/HSplitContainer/SpinBoxForStat.value

func _on_set_minutes_btn_pressed():
	$"../selectSound".pitch_scale = randf_range(0.8, 1.2)
	$"../selectSound".play()
	GameManager.minutes = $DebugMenu/ScrollContainer/VBoxContainer/Minutes/SpinBoxForMinutes.value
	get_parent().minutes = GameManager.minutes

func _on_set_seconds_btn_pressed():
	$"../selectSound".pitch_scale = randf_range(0.8, 1.2)
	$"../selectSound".play()
	GameManager.seconds = $DebugMenu/ScrollContainer/VBoxContainer/Seconds/SpinBoxForSeconds.value
	get_parent().time = GameManager.seconds

func _on_set_hp_pressed():
	$"../selectSound".pitch_scale = randf_range(0.8, 1.2)
	$"../selectSound".play()
	if GameManager.curr_health < Upgrades.stats["max_health"]:
		GameManager.curr_health += $DebugMenu/ScrollContainer/VBoxContainer/HP/SpinBoxForHP.value
