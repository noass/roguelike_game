extends Node

var stats = {
	"physical_damage": 3,
	"attack_size": 2.1,
	#"attack_speed": 1,
	"attack_cooldown": 1.5,
	"pickup_range": 36,
	"move_speed": 5000.0,
	"max_health": 50,
	"xp_multiplier": 1,
	"health_regen": 1
}

var upgrades = [
	{
		"title": "[center][color=#fff0a6]PHYSICAL DAMAGE[/color][/center]",
		"description": "[left]Gives [color=#00ff44]+1[/color] [color=#fff0a6]Physical Damage[/color].[/left]",
		"give": func(): stats["physical_damage"] += 1
	},
	{
		"title": "[center][color=#fff0a6]ATTACK SIZE[/color][/center]",
		"description": "[left]Gain [color=#00ff44]x0.6[/color] [color=#fff0a6]Size[/color] to [color=#fff0a6]Attacks[/color].[/left]",
		"give": func(): stats["attack_size"] += 0.6
	},
	{
		"title": "[center][color=#fff0a6]ATTACK COOLDOWN[/color][/center]",
		"description": "[left]Get [color=#00ff44]-0.02s[/color] [color=#fff0a6]Cooldown[/color] to [color=#fff0a6]Attacks[/color].[/left]",
		"give": func(): upgrade_attack_cooldown()
	},
	#{
		#"title": "[center][color=#fff0a6]ATTACK SPEED[/color][/center]",
		#"description": "[left]Gain [color=#00ff44]x0.35[/color] [color=#fff0a6]Speed[/color] to [color=#fff0a6]Attacks[/color].[/left]",
		#"give": func(): stats["attack_speed"] += 0.35
	#},
	{
		"title": "[center][color=#fff0a6]MOVE SPEED[/color][/center]",
		"description": "[left]Gives [color=#00ff44]+650[/color] [color=#fff0a6]Movement Speed[/color].[/left]",
		"give": func(): stats["move_speed"] += 650
	},
	{
		"title": "[center][color=#fff0a6]MAX HEALTH[/color][/center]",
		"description": "[left]Gives [color=#00ff44]+15[/color] [color=#fff0a6]Max Health[/color].[/left]",
		"give": func(): stats["max_health"] += 15
	},
	{
		"title": "[center][color=#fff0a6]MORE XP[/color][/center]",
		"description": "[left]Gain [color=#00ff44]x0.15[/color] [color=#fff0a6]More XP[/color].[/left]",
		"give": func(): stats["xp_multiplier"] += 0.15
	},
	{
		"title": "[center][color=#fff0a6]PICKUP RANGE[/color][/center]",
		"description": "[left]Gain [color=#00ff44]+15[/color] [color=#fff0a6]Pickup Range[/color].[/left]",
		"give": func(): stats["pickup_range"] += 15
	},
	{
		"title": "[center][color=#00ff44]HEAL[/color][/center]",
		"description": "[left]Heal [color=#00ff44]+16 health[/color].[/left]",
		"give": func(): GameManager.curr_health += 16
	},
	{
		"title": "[center][color=#fff0a6]HEALTH REGEN[/color][/center]",
		"description": "[left]Gain [color=#00ff44]+0.8[/color] [color=#fff0a6]Health Regen[/color] every 20 seconds.[/left]",
		"give": func(): stats["health_regen"] += 0.8
	}
	#add more attacks
]

func upgrade_attack_cooldown():
	if stats["attack_cooldown"] >= 0.35:
		stats["attack_cooldown"] -= 0.02
	else:
		upgrades.remove_at(2)
