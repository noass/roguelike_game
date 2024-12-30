extends CharacterBody2D

@export var target: CharacterBody2D # assign target on instantiation
@export var move_speed: float = 2000.0
@export var health: int = 10
@export var damage_to_player = 5
@export var knockback_strength: float = 200.0
@export var xp_to_drop: PackedScene = preload("res://Scenes/xp_pickup_1.tscn")
@export var damage_to_player_cooldown = 0.5

var damage_number = preload("res://Scenes/damage_number.tscn")

var dir = Vector2.ZERO
var knockback = Vector2.ZERO
var flash_time = 0.15

func _ready():
	if !target:
		target = get_parent().get_node("Player")

func _physics_process(delta):
	if target:
		dir = (target.position - position).normalized() * delta
		velocity = dir * move_speed + knockback
		if position.x > target.position.x:
			get_node("Sprite2D").flip_h = false
		else:
			get_node("Sprite2D").flip_h = true
			
	move_and_slide()
	
	knockback = lerp(knockback, Vector2.ZERO, 7 * delta)
	
func _process(delta):
	if health <= 0:
		var xp_instance = xp_to_drop.instantiate()
		xp_instance.position = position
		get_parent().add_child(xp_instance)
		queue_free()
	
	if $HitPlayerRange.overlaps_body(target):
		damage_to_player_cooldown += delta
		if damage_to_player_cooldown >= 0.5:
			if not GameManager.invincible:
				target.hit(damage_to_player)
			damage_to_player_cooldown = 0
	else:
		damage_to_player_cooldown = 0.5
	
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
