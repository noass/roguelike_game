extends Area2D

var thrown = false
var fly_speed = 300.0

var dir = Vector2.ZERO

var actual_slime = preload("res://Scenes/slime.tscn")

func _physics_process(delta):
	if not thrown:
		if get_parent().get_node("Player").position.x < position.x:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
		dir = (get_parent().get_node("Player").position - position).normalized()
		thrown = true
	position += dir * fly_speed * delta
	if fly_speed > 0:
		fly_speed -= 150 * delta
	else:
		queue_free()
		var actual_slime_instance = actual_slime.instantiate()
		actual_slime_instance.position = global_position
		get_parent().add_child(actual_slime_instance)

func _on_body_entered(body):
	if body.name == "Player":
		queue_free()
		var actual_slime_instance = actual_slime.instantiate()
		actual_slime_instance.position = global_position
		get_parent().add_child(actual_slime_instance)
	
