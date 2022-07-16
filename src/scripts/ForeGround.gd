extends Node2D
var first = true

func _on_Area2D_body_entered(body):
	if body.name == "player":
		if first:
			first = false
		else:
			$AnimationPlayer.play_backwards("New Anim")

func _on_Area2D_body_exited(body):
	if body.name == "player":
		$AnimationPlayer.play("New Anim")
