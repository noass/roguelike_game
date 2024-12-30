extends CharacterBody2D

var target: CharacterBody2D # assign target on instantiation
var move_speed: float = 1800.0
var health: int = 28
var damage_to_player = 8
var knockback_strength: float = 100.0
var xp_to_drop: PackedScene = preload("res://Scenes/xp_pickup_1.tscn")
var damage_to_player_cooldown = 0.5

var damage_number = preload("res://Scenes/damage_number.tscn")

var dir = Vector2.ZERO
var knockback = Vector2.ZERO
var flash_time = 0.15
var facing_left = false
var throwing = false

var thrown_slime = preload("res://Scenes/Bosses/slimeThrown.tscn")

var slimes_thrown_count = 0
var max_slimes_thrown = 2

func _ready():
	if !target:
		target = get_parent().get_node("Player")

func _physics_process(delta):
	if target and not throwing:
		dir = (target.position - position).normalized() * delta
		velocity = dir * move_speed + knockback
		move_and_slide()
	
	knockback = lerp(knockback, Vector2.ZERO, 7 * delta)

func _process(delta):
	if health <= 0:
		var xp_instance = xp_to_drop.instantiate()
		xp_instance.position = position
		get_parent().add_child(xp_instance)
		queue_free()
	
	if target.position.x < position.x and not facing_left:
		scale.x = -1
		facing_left = true
	elif target.position.x > position.x and facing_left:
		scale.x = -1
		facing_left = false
	
	if $HitPlayerRange.overlaps_body(target):
		damage_to_player_cooldown += delta
		if damage_to_player_cooldown >= 0.5:
			if not GameManager.invincible:
				target.hit(damage_to_player)
			damage_to_player_cooldown = 0
	else:
		damage_to_player_cooldown = 0.5
		
	if throwing and slimes_thrown_count < max_slimes_thrown:
		$AnimationPlayer.play("throw")
	else:
		$AnimationPlayer.play("walk")
		
	if throwing and slimes_thrown_count >= max_slimes_thrown:
		$AnimationPlayer.play("walk")
		throwing = false
		
func hit(damage_dealt):
	health -= damage_dealt
	var damage_number_instance = damage_number.instantiate()
	damage_number_instance.position = position
	damage_number_instance.get_node("Label").text = str(damage_dealt)
	get_tree().current_scene.add_child(damage_number_instance)
	dir = target.global_position.direction_to(global_position)
	var explosion_force = dir * knockback_strength
	knockback = explosion_force
	get_node("Sprite2D").material.set_shader_parameter("flash_modifier", 1)
	await get_tree().create_timer(flash_time).timeout
	get_node("Sprite2D").material.set_shader_parameter("flash_modifier", 0)


func _on_range_to_throw_body_exited(body):
	if body == target:
		slimes_thrown_count = 0
		throwing = false

func _on_range_to_throw_body_entered(body):
	if body == target:
		throwing = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "throw":
		var thrown_slime_instance = thrown_slime.instantiate()
		thrown_slime_instance.position = $ThrowOrigin.global_position
		get_parent().add_child(thrown_slime_instance)
		slimes_thrown_count += 1
