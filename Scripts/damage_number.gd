extends Node2D

const MOVE_SPEED_UP = 20.0
const FADE_OUT_SPEED = 0.5

func _process(delta):
	position.y -= MOVE_SPEED_UP * delta
	modulate.a -= FADE_OUT_SPEED * delta
	if modulate.a <= 0.0:
		queue_free()
