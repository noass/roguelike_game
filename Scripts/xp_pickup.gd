extends Sprite2D

@export var xp_gain: int = 2

var collecting = false

func _process(delta):
	var player = get_tree().current_scene.get_node("Player")
	if $Collect_Range.overlaps_body(player) and !GameManager.dead:
		collecting = true
	if collecting:
		position.x = lerpf(position.x, player.position.x, 5 * delta)
		position.y = lerpf(position.y, player.position.y, 5 * delta)
		if position.distance_to(player.position) <= 18:
			$pickupSound.pitch_scale = randf_range(0.8, 1.2)
			$pickupSound.play()
			GameManager.curr_xp += xp_gain * Upgrades.stats["xp_multiplier"]
			queue_free()
	$Collect_Range/CollisionShape2D.shape.radius = Upgrades.stats["pickup_range"]
