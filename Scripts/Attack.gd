extends Node2D

@export var damage: float = 3.0

func _process(_delta):
	damage = Upgrades.stats["physical_damage"]
	scale = Vector2(Upgrades.stats["attack_size"], Upgrades.stats["attack_size"])
	#get_node("AnimationPlayer").speed_scale = Upgrades.stats["attack_speed"]

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		$Area2D/CollisionPolygon2D.set_deferred("disabled", true)
		body.hit(damage)
