extends Area2D

var thrown = false
var stop = false
var fly_speed = 300.0
var max_height = 70.0
var falling = false
var start_pos
var tickFlash = false

var dir = Vector2.ZERO

var explosion = preload("res://Scenes/explosion.tscn")

func _ready():
	$bombSHHHHH.pitch_scale = randf_range(0.8, 1.2)
	start_pos = position

func _physics_process(delta):
	if not thrown:
		if get_parent().get_node("Player").position.x < position.x:
			$Sprite2D.flip_h = true
			$GPUParticles2D.position.x = -10
		else:
			$Sprite2D.flip_h = false
			$GPUParticles2D.position.x = 10
		dir = (get_parent().get_node("Player").position - position).normalized()
		thrown = true
	if not stop:
		position.x += dir.x * fly_speed * delta
		position.y += dir.y * fly_speed * delta
		#if position.y >= start_pos.y - max_height and not falling:
			#position.y -= dir.y * fly_speed * delta
		#else:
			#falling = true
		#if falling:
			#position.y += dir.y * fly_speed * delta
		if fly_speed > 0:
			fly_speed -= 150 * delta
		elif fly_speed <= 0:
			stop = true
			
func _on_body_entered(body):
	if body.name == "Player":
		stop = true

func _on_bomb_tick_timer_timeout():
	$BombTickTimer.wait_time -= 0.1
	if $BombTickTimer.wait_time <= 0.1:
		var explosion_instance = explosion.instantiate()
		explosion_instance.position = position
		get_tree().current_scene.add_child(explosion_instance)
		queue_free()
	if not tickFlash:
		get_node("Sprite2D").material.set_shader_parameter("flash_modifier", 0)
		tickFlash = true
	else:
		get_node("Sprite2D").material.set_shader_parameter("flash_modifier", 1)
		tickFlash = false
