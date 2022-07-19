extends Node2D

func _on_Area2D_body_entered(body):
	if body.name == "player":
		$AnimationPlayer.play_backwards("New Anim")

func _on_Area2D_body_exited(body):
	if body.name == "player":
		$AnimationPlayer.play("New Anim")
