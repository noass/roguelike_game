extends Control

var time = 0.0
var minutes = 0
var remaining_rerolls = 3

var upgrades_generated = false

var deathSoundPlayed = false

func _ready():
	#GameManager.curr_xp = 20
	GameManager.curr_health = Upgrades.stats["max_health"]

func _process(delta):
	if GameManager.dead and not deathSoundPlayed:
		$deathSound.pitch_scale = randf_range(0.8, 1.2)
		$deathSound.play()
		deathSoundPlayed = true
	$FPSTEXT.text = "FPS: " + str(Engine.get_frames_per_second())
	$LevelText.text = str(GameManager.curr_xp) + "/" + str(GameManager.xp_needed_for_lvl_up)
	$LevelProgress.value = GameManager.curr_xp
	$LevelProgress.max_value = GameManager.xp_needed_for_lvl_up
	$ActualLevelText.text = "Level: " + str(GameManager.level)
	$LevelUpGUI/Upgrades/LevelOption1/RerollsRemainingText.text = "Rerolls remaining: " + str(remaining_rerolls)
	if GameManager.curr_xp >= GameManager.xp_needed_for_lvl_up:
		$levelUpSound.pitch_scale = randf_range(0.8, 1.2)
		$levelUpSound.play()
		GameManager.level += 1
		GameManager.curr_xp = 0
		GameManager.xp_needed_for_lvl_up = round(GameManager.xp_needed_for_lvl_up * GameManager.xp_increase_ratio)
		generate_upgrades()
		$LevelUpGUI.show()
		get_tree().paused = true
		
	if not get_tree().paused:
		time += delta
		var str_minutes = str(minutes)
		var str_seconds = str(round(time))
		if round(time) >= 60:
			time = 0
			minutes += 1
		if round(time) < 10:
			str_seconds = "0" + str(round(time))
		if minutes < 10:
			str_minutes = "0" + str(minutes)
		$TimeText.text = str_minutes + ":" + str_seconds
		GameManager.minutes = minutes
		GameManager.seconds = round(time)
	
	$HPBar.max_value = Upgrades.stats["max_health"]
	$HPBar.value = GameManager.curr_health
	$HPText.text = str(GameManager.curr_health) + "/" + str(Upgrades.stats["max_health"])
		
	# removed : Attack Speed -- x{attack_speed}
	$PauseMenu/Panel/StatsText.text = "[left]STATS:

Attack Cooldown -- {attack_cooldown}s
Attack Size -- x{attack_size}
Health Regen -- {health_regen}
Max Health -- {max_health}
Movement Speed -- {move_speed}
Physical Damage -- {physical_damage}
Pickup Range -- {pickup_range}
XP Multiplier -- x{xp_multiplier}
[/left]
".format({
	"attack_cooldown": str(Upgrades.stats["attack_cooldown"]), 
	"attack_size": str(Upgrades.stats["attack_size"]), 
	#"attack_speed": str(Upgrades.stats["attack_speed"]),
	"health_regen": str(Upgrades.stats["health_regen"]),
	"max_health": str(Upgrades.stats["max_health"]),
	"move_speed": str(Upgrades.stats["move_speed"]),
	"physical_damage": str(Upgrades.stats["physical_damage"]),
	"pickup_range": str(Upgrades.stats["pickup_range"]),
	"xp_multiplier": str(Upgrades.stats["xp_multiplier"])
})
		
func generate_upgrades():
	if !upgrades_generated:
		for i in range(1, $LevelUpGUI/Upgrades.get_child_count()+1):
			var random_upgrade = randi_range(0, Upgrades.upgrades.size()-1)
			get_node("LevelUpGUI/Upgrades/LevelOption" + str(i) + "/VBoxContainer/VBoxContainer/Title").text = Upgrades.upgrades[random_upgrade]["title"]
			get_node("LevelUpGUI/Upgrades/LevelOption" + str(i) + "/VBoxContainer/Description").text = Upgrades.upgrades[random_upgrade]["description"]
			get_node("LevelUpGUI/Upgrades/LevelOption" + str(i) + "/VBoxContainer/ChooseBTN").set_meta("upgrade_index", random_upgrade)
		upgrades_generated = true

func _on_choose_btn_1_pressed():
	$selectSound.pitch_scale = randf_range(0.8, 1.2)
	$selectSound.play()
	get_tree().paused = false
	upgrades_generated = false
	Upgrades.upgrades[$LevelUpGUI/Upgrades/LevelOption1/VBoxContainer/ChooseBTN.get_meta("upgrade_index")]["give"].call()
	$LevelUpGUI.hide()

func _on_choose_btn_2_pressed():
	$selectSound.pitch_scale = randf_range(0.8, 1.2)
	$selectSound.play()
	get_tree().paused = false
	upgrades_generated = false
	Upgrades.upgrades[$LevelUpGUI/Upgrades/LevelOption2/VBoxContainer/ChooseBTN.get_meta("upgrade_index")]["give"].call()
	$LevelUpGUI.hide()

func _on_choose_btn_3_pressed():
	$selectSound.pitch_scale = randf_range(0.8, 1.2)
	$selectSound.play()
	get_tree().paused = false
	upgrades_generated = false
	Upgrades.upgrades[$LevelUpGUI/Upgrades/LevelOption3/VBoxContainer/ChooseBTN.get_meta("upgrade_index")]["give"].call()
	$LevelUpGUI.hide()

func _on_reroll_btn_pressed():
	if remaining_rerolls > 0:
		$selectSound.pitch_scale = randf_range(0.8, 1.2)
		$selectSound.play()
		upgrades_generated = false
		remaining_rerolls -= 1
		$LevelUpGUI/Upgrades/LevelOption1/RerollsRemainingText.text = "Rerolls remaining: " + str(remaining_rerolls)
		generate_upgrades()
