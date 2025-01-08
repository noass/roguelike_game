extends Area2D

func _ready():
	$explosionSound.pitch_scale = randf_range(0.8, 1.2)
	$GPUParticles2D.emitting = true
	get_tree().current_scene.find_child("Player").apply_camera_shake()

func _on_body_entered(body):
	body.hit(10)
	$CollisionShape2D.set_deferred("disabled", true)

func _on_gpu_particles_2d_finished():
	queue_free()
