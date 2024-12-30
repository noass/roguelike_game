extends CharacterBody2D

var dir = Vector2.ZERO
var flash_time = 0.15

func _physics_process(delta):
	if !GameManager.dead:
		dir = Vector2(Input.get_axis("LEFT", "RIGHT"), Input.get_axis("UP", "DOWN")).normalized() * delta
		velocity = dir * Upgrades.stats["move_speed"]
		
		#if Input.is_action_just_pressed("SPACEBAR"):
			#for i in get_parent().get_tree().get_nodes_in_group("Enemy"):
				#i.hit(3)

		move_and_slide()

func hit(damage_dealt):
	if !GameManager.dead:
		GameManager.curr_health -= damage_dealt
		get_node("Sprite2D").material.set_shader_parameter("flash_modifier", 1)
		await get_tree().create_timer(flash_time).timeout
		get_node("Sprite2D").material.set_shader_parameter("flash_modifier", 0)

func _on_regen_health_timer_timeout():
	if GameManager.curr_health < Upgrades.stats["max_health"]:
		GameManager.curr_health += Upgrades.stats["health_regen"]
