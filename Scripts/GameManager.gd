extends Node

var minutes = 0
var seconds = 0

var player
var invincible = false
var dead = false
@onready var curr_health = Upgrades.stats["max_health"]
var level = 1
var curr_xp = 0
var xp_needed_for_lvl_up = 20
var xp_increase_ratio = 1.2

var slash = preload("res://Scenes/slash.tscn")

var attack_cooldowns = {}
var attack_timers = {}

func _enter_tree():
	curr_health = Upgrades.stats["max_health"]

func _ready():
	player = get_tree().current_scene.get_node("Player")
	curr_health = Upgrades.stats["max_health"]
	
	for attack_name in attack_cooldowns.keys():
		attack_timers[attack_name] = 0.0

func _process(delta):
	DisplayServer.window_set_title("Game | FPS: " + str(Engine.get_frames_per_second()))
	
	for attack_name in attack_timers.keys():
		if attack_timers[attack_name] > 0:
			attack_timers[attack_name] -= delta
			
	attack_cooldowns = {
		"slash": Upgrades.stats["attack_cooldown"]
	}
			
	if curr_health != null and curr_health <= 0:
		#player = get_tree().current_scene.get_node("Player")
		#player.get_node("Sprite2D").hide()
		dead = true
	if curr_health != null:
		if curr_health > Upgrades.stats["max_health"]:
			curr_health = Upgrades.stats["max_health"]
	
	if can_attack("slash") and !dead:
		slash_hit()
		reset_cooldown("slash")

func can_attack(attack_name):
	return attack_timers.get(attack_name, 0.0) <= 0.0

func reset_cooldown(attack_name):
	attack_timers[attack_name] = attack_cooldowns.get(attack_name, 0.0)

func find_nearest_enemy():
	var nearest_enemy = null
	var nearest_distance = INF
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var distance = player.position.distance_to(enemy.position)
		if distance < nearest_distance:
			nearest_enemy = enemy
			nearest_distance = distance
	return nearest_enemy

func slash_hit():
	if get_tree().current_scene:
		player = get_tree().current_scene.get_node("Player")
		var slash_instance = slash.instantiate()
		slash_instance.position = player.position
		var nearest_enemy = find_nearest_enemy()
		if nearest_enemy:
			var direction = nearest_enemy.position - slash_instance.position
			slash_instance.rotation = direction.angle()
			slash_instance.rotation += deg_to_rad(180)
		get_tree().current_scene.add_child(slash_instance)
