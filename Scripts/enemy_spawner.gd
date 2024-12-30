extends Path2D

@export var player: CharacterBody2D

var boss_spawned = false

var goblin = preload("res://Scenes/goblin.tscn")
var slime = preload("res://Scenes/slime.tscn")

var ogre = preload("res://Scenes/Bosses/Ogre.tscn")

func _process(delta):
	if int(GameManager.minutes) % 5 == 0 and GameManager.minutes > 0 and not boss_spawned:
		global_position.x = player.global_position.x - (get_viewport_rect().size.x/2)
		global_position.y = player.global_position.y - (get_viewport_rect().size.y/2)
		$PathFollow2D.progress_ratio = randf_range(0.0, 1.0)
		var instance = ogre.instantiate()
		instance.global_position = $PathFollow2D.global_position
		get_parent().add_child(instance)
		boss_spawned = true
	if int(GameManager.minutes) % 5 != 0 and GameManager.minutes > 0 and boss_spawned:
		boss_spawned = false

func _on_goblin_spawn_timer_timeout():
	if !GameManager.dead:
		global_position.x = player.global_position.x - (get_viewport_rect().size.x/2)
		global_position.y = player.global_position.y - (get_viewport_rect().size.y/2)
		$PathFollow2D.progress_ratio = randf_range(0.0, 1.0)
		var instance = goblin.instantiate()
		instance.global_position = $PathFollow2D.global_position
		get_parent().add_child(instance)

func _on_slime_spawn_timer_timeout():
	if GameManager.minutes >= 1 and !GameManager.dead:
		global_position.x = player.global_position.x - (get_viewport_rect().size.x/2)
		global_position.y = player.global_position.y - (get_viewport_rect().size.y/2)
		$PathFollow2D.progress_ratio = randf_range(0.0, 1.0)
		var instance = slime.instantiate()
		instance.global_position = $PathFollow2D.global_position
		get_parent().add_child(instance)
